//
//  LoginController.swift
//  Toast Delivery
//

import Foundation

enum LoginError: Error {
    case decoding
    case networking(Error)
}

final class LoginController {
    private let session: URLSession
    private let clientId: String
    private let clientSecret: String

    // TODO: get the client credentials for your app here (we already registered it for you): https://me.sumup.com/developers
    init(clientId: String, clientSecret: String) {
        self.session = URLSession(configuration: URLSessionConfiguration.default)
        self.clientId = clientId
        self.clientSecret = clientSecret
    }

    func doLogin(_ completion: @escaping (Result<TokenResponse, LoginError>) -> Void) {
        let bodyComponents = [
            "grant_type": "client_credentials",
            "client_id": clientId,
            "client_secret": clientSecret
        ]

        let body = bodyComponents.map { "\($0)=\($1)" }.joined(separator: "&")
        var request = URLRequest(url: URL(string: "https://api.sumup.com/token")!)
        request.httpMethod = "POST"
        request.httpBody = body.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.networking(error)))
                return
            }

            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase

            guard let safeData = data, let tokenResponse = try? decoder.decode(TokenResponse.self, from: safeData) else {
                if let data = data {
                    print("Received invalid data: \(String(data: data, encoding: .utf8)!)")
                }
                completion(.failure(.decoding))
                return
            }

            completion(.success(tokenResponse))
        }.resume()
    }
}
