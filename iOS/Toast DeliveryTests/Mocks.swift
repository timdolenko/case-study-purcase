//
//  Mocks.swift
//  Toast DeliveryTests
//

@testable import ToastDelivery

extension CheckoutResponse {
    static var stub: CheckoutResponse {
        .init(
            reference: "",
            amount: 2.99,
            currencyCode: "EUR",
            identifier: "id",
            status: "failed",
            date: Date()
        )
    }
}

extension Card {
    static var stub: Card {
        .init(
            number: "4242424242424242",
            expiryYear: "25",
            expiryMonth: "12",
            cvv: "569",
            ownersName: "Bob Smith",
            zipCode: "13510"
        )
    }
}
