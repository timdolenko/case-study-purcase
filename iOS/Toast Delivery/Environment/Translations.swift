//
//  Translations.swift
//  Toast Delivery
//

import Foundation

struct Translations {
    var card = Card()
    var cart = Cart()
}

extension Translations {
    struct Card {
        var detailsEntry = CardDetailsEntry()
        var doneButton = "Done"
    }
    struct Cart {
        var toastName: String = "<Selected Toast>"
        var price: String = "<Price>"
    }
}
