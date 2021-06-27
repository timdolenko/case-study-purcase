//
//  CheckoutRepository.swift
//  Toast Delivery
//

import Foundation
import Networking
import Combine

final class CheckoutRepositoryLive {
    
    private var service: DataTransferService {
        env.resolve()
    }
    
    private let endpoints = Endpoints.Checkouts.self
    
    func processCheckout(
        checkoutId: String,
        card: Card
    ) -> AnyPublisher<PaymentResult, Error> {
        let request = ProcessCheckoutRequestDTO(
            paymentType: "card",
            card: .init(
                name: card.ownersName,
                number: card.number,
                expiryYear: card.expiryYear,
                expiryMonth: card.expiryMonth,
                cvv: card.cvv,
                zipCode: card.zipCode
            )
        )
        
        let endpoint = endpoints.processCheckout(with: checkoutId, request: request)
        
        return service.request(with: endpoint)
            .map { response -> PaymentResult in
                switch response.status {
                case .paid:
                    return .successful
                case .pending:
                    return .pending
                case .failed:
                    return .failed
                }
            }
            .eraseToAnyPublisher()
    }
}

extension CheckoutRepositoryLive: CheckoutRepository {}

protocol CheckoutRepository {
    func processCheckout(
        checkoutId: String,
        card: Card
    ) -> AnyPublisher<PaymentResult, Error>
}
