//
//  CardValidator.swift
//  Toast Delivery
//

import Foundation

protocol CardValidator {
    func validate(_ card: Card) -> Bool
}

class CardValidatorLive: CardValidator {
    
    func validate(_ card: Card) -> Bool {
        guard card.number.isNumber,
              card.expiryYear.isNumber,
              card.expiryYear.count == 2,
              card.expiryMonth.isNumber,
              card.expiryMonth.count == 2,
              card.cvv.isNumber,
              card.zipCode.isNumber,
              !card.ownersName.isEmpty,
              !card.ownersName.containsNumbers
        else { return false }
        
        return true
    }
}

extension String  {
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
    var containsNumbers: Bool {
        rangeOfCharacter(from: CharacterSet.decimalDigits) != nil
    }
}
