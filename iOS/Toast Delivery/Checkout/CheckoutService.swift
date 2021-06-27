//
//  CheckoutService.swift
//  Toast Delivery
//

import Foundation
import Combine

protocol ToastCheckoutService {
    func createCheckout(toast: ToastItem) -> AnyPublisher<CheckoutResponse, Error>
    func processCheckout(with card: Card, checkout: CheckoutResponse) -> AnyPublisher<PaymentResult, Error>
}

class ToastCheckoutServiceLive: ToastCheckoutService {
    
    var checkoutRepository: CheckoutRepository {
        env.resolve()
    }
    
    func createCheckout(toast: ToastItem) -> AnyPublisher<CheckoutResponse, Error> {
       env.loginService.retrieveAccessToken()
            .flatMap { [unowned self] accessToken in
                createCheckout(accessToken: accessToken, toast: toast)
            }
            .eraseToAnyPublisher()
    }
    
    func processCheckout(with card: Card, checkout: CheckoutResponse) -> AnyPublisher<PaymentResult, Error> {
        checkoutRepository
            .processCheckout(checkoutId: checkout.identifier, card: card)
            .eraseToAnyPublisher()
    }
    
    private func createCheckout(accessToken: String, toast: ToastItem) -> Future<CheckoutResponse, Error> {
        Future() { promise in
            
            let service = SumUpCheckoutService(
                merchantCode: env.secrets.merchantCode,
                accessToken: accessToken
            )
            
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
