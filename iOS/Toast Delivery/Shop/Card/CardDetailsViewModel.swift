//
//  CardDetailsViewModel.swift
//  Toast Delivery
//

import Foundation
import Combine

struct Card {
    var number: String?
    var expiryYear: String?
    var expiryMonth: String?
    var cvv: String?
    var ownersName: String?
    var zipCode: String?
}

class CardDetailsViewModel {
    @Published var card = Card()
    @Published var isCardValid = false
    
    var didTapDone = PassthroughSubject<Void, Never>()
    
    var bindings = Set<AnyCancellable>()
    
    init() {
        bind()
    }
    
    private func bind() {
        $card
            .map { env.cardValidator.validate($0) }
            .assign(to: &$isCardValid)
    }
}
