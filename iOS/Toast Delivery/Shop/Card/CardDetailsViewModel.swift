//
//  CardDetailsViewModel.swift
//  Toast Delivery
//

import Foundation
import Combine

struct CardViewModel {
    var number: String?
    var expiryYear: String?
    var expiryMonth: String?
    var cvv: String?
    var ownersName: String?
    var zipCode: String?
}

class CardDetailsViewModel {
    @Published var card = CardViewModel()
    @Published var isCardValid = false
    @Published var validatedCard: Card? = nil
    
    var finishedWithCard = PassthroughSubject<Card, Never>()
    var failure = PassthroughSubject<Error, Never>()
    var result = PassthroughSubject<PaymentResult, Never>()
    var checkout = CurrentValueSubject<CheckoutResponse?, Never>(nil)
    
    var viewDidLoad = PassthroughSubject<Void, Never>()
    var didTapDone = PassthroughSubject<Void, Never>()
    
    var bindings = Set<AnyCancellable>()
    
    private let toast: ToastItem
    
    init(toast: ToastItem) {
        self.toast = toast
        bind()
    }
    
    private func bind() {
        viewDidLoad
            .flatMap { [unowned self] in
                env.checkoutService.createCheckout(toast: toast)
            }
            .catch({ [weak self] error -> AnyPublisher<CheckoutResponse, Never> in
                self?.failure.send(error)
                return Empty<CheckoutResponse, Never>(completeImmediately: true)
                    .eraseToAnyPublisher()
            }).sink { [weak self] response in
                self?.checkout.send(response)
            }
            .store(in: &bindings)
        
        $card
            .compactMap { card in
                guard let number = card.number,
                      let yy = card.expiryYear,
                      let mm = card.expiryMonth,
                      let cvv = card.cvv,
                      let ownersName = card.ownersName,
                      let zipCode = card.zipCode
                else { return nil }
                
                return Card(
                    number: number,
                    expiryYear: yy,
                    expiryMonth: mm,
                    cvv: cvv,
                    ownersName: ownersName,
                    zipCode: zipCode
                )
            }
            .map { [weak self] (card: Card) in
                if env.cardValidator.validate(card) && self?.checkout.value != nil {
                    return card
                }
                return nil
            }
            .assign(to: &$validatedCard)
        
        $validatedCard
            .map { $0 != nil }
            .assign(to: &$isCardValid)
        
        didTapDone
            .compactMap { [weak self] in
                guard let self = self,
                      let checkout = self.checkout.value,
                      let card = self.validatedCard
                else { return nil }
                
                return (checkout, card)
            }
            .flatMap { (checkout, card) -> AnyPublisher<PaymentResult, Error> in
                env.checkoutService.processCheckout(
                    with: card,
                    checkout: checkout
                )
            }
            .replaceError(with: .failed)
            .receive(subscriber: AnySubscriber(result))
    }
}
