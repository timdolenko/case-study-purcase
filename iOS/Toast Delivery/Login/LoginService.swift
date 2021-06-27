//
//  LoginService.swift
//  Toast Delivery
//

import Foundation
import Combine
import CoreTools

protocol LoginService {
    func retrieveAccessToken() -> AnyPublisher<String, Error>
}

fileprivate struct Token {
    let response: TokenResponse
    let receivedAt: Date
    var isValid: Bool {
        receivedAt.addingTimeInterval(TimeInterval(response.expiresIn)) > Date.now
    }
}

class LoginServiceLive: LoginService {
    
    private var token: Token? = nil
    
    private lazy var loginController = LoginController(
        clientId: env.secrets.clientId,
        clientSecret: env.secrets.clientSecret
    )
    
    func retrieveAccessToken() -> AnyPublisher<String, Error> {
        if let token = token, token.isValid {
            return Just(token.response.accessToken)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        return requestToken()
            .handleEvents(receiveOutput: { [unowned self] in
                token = Token(response: $0, receivedAt: .now)
            })
            .map(\.accessToken)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    private func requestToken() -> AnyPublisher<TokenResponse, LoginError> {
        Future() { [unowned self] promise in
            loginController.doLogin { result in
                promise(result)
            }
        }.eraseToAnyPublisher()
    }
}
