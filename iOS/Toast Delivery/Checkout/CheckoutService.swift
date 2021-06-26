//
//  CheckoutService.swift
//  Toast Delivery
//

import Foundation
import Combine

protocol ToastCheckoutService {
    func checkout(toast: ToastItem) -> AnyPublisher<CheckoutResponse, Error>
}

class ToastCheckoutServiceLive: ToastCheckoutService {
    
    func checkout(toast: ToastItem) -> AnyPublisher<CheckoutResponse, Error> {
       env.loginService.retrieveAccessToken()
            .flatMap { [unowned self] accessToken in
                createCheckout(accessToken: accessToken, toast: toast)
                    .eraseToAnyPublisher()
            }.eraseToAnyPublisher()
    }
    
    private func createCheckout(accessToken: String, toast: ToastItem) -> Future<CheckoutResponse, Error> {
        Future() { promise in
            
            let service = SumUpCheckoutService(merchantCode: Secrets.id, accessToken: accessToken)
            
            let reference = UUID().uuidString
            
            let request = CheckoutRequest(
                reference: reference,
                amount: toast.price,
                currencyCode: env.currencyService.currency
            )
            
            service.createCheckout(with: request) { response, error in
                if let response = response {
                    promise(.success(response))
                } else if let error = error {
                    promise(.failure(error))
                }
            }
        }
    }
}

extension SumUpCheckoutService {
    
}
