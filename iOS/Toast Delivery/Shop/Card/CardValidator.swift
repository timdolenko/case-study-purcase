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
        guard let number = card.number,
              let yy = card.expiryYear,
              let mm = card.expiryMonth,
              let cvv = card.cvv,
              let ownersName = card.ownersName,
              let zipCode = card.zipCode
        else { return false }
        
        guard number.isNumber,
              yy.isNumber,
              yy.count == 2,
              mm.isNumber,
              mm.count == 2,
              cvv.isNumber,
              zipCode.isNumber,
              !ownersName.isEmpty,
              !ownersName.containsNumbers
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
