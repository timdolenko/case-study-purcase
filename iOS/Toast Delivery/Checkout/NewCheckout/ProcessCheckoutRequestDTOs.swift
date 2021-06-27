//
//  ProcessCheckoutRequestDTOs.swift
//  Toast Delivery
//

import Foundation

struct ProcessCheckoutRequestDTO: Codable {
    struct Card: Codable {
        let name, number, expiryYear, expiryMonth: String
        let cvv, zipCode: String

        enum CodingKeys: String, CodingKey {
            case name, number
            case expiryYear = "expiry_year"
            case expiryMonth = "expiry_month"
            case cvv
            case zipCode = "zip_code"
        }
    }
    
    let paymentType: String
    let card: Card

    enum CodingKeys: String, CodingKey {
        case paymentType = "payment_type"
        case card
    }
}

struct ProcessCheckoutResponseDTO: Codable {
    enum Status: String, Codable {
        case pending = "PENDING"
        case failed = "FAILED"
        case paid = "PAID"
    }

    // MARK: - Mandate
    struct Mandate: Codable {
        let type, status, merchantCode: String

        enum CodingKeys: String, CodingKey {
            case type, status
            case merchantCode = "merchant_code"
        }
    }

    // MARK: - Transaction
    struct Transaction: Codable {
        let id, transactionCode: String
        let amount: Double
        let currency, timestamp, status, paymentType: String
        let installmentsCount: Int
        let merchantCode: String
        let vatAmount, tipAmount: Double
        let entryMode: String
        let authCode: String?
        let internalID: Int

        enum CodingKeys: String, CodingKey {
            case id
            case transactionCode = "transaction_code"
            case amount, currency, timestamp, status
            case paymentType = "payment_type"
            case installmentsCount = "installments_count"
            case merchantCode = "merchant_code"
            case vatAmount = "vat_amount"
            case tipAmount = "tip_amount"
            case entryMode = "entry_mode"
            case authCode = "auth_code"
            case internalID = "internal_id"
        }
    }
    
    let checkoutReference: String
    let amount: Double
    let currency, payToEmail, merchantCode, welcomeDescription: String
    let returnURL: String?
    let id: String
    let status: Status
    let date: String
    let validUntil: String?
    let customerID: String?
    let mandate: Mandate?
    let transactions: [Transaction]
    let transactionCode, transactionID: String

    enum CodingKeys: String, CodingKey {
        case checkoutReference = "checkout_reference"
        case amount, currency
        case payToEmail = "pay_to_email"
        case merchantCode = "merchant_code"
        case welcomeDescription = "description"
        case returnURL = "return_url"
        case id, status, date
        case validUntil = "valid_until"
        case customerID = "customer_id"
        case mandate, transactions
        case transactionCode = "transaction_code"
        case transactionID = "transaction_id"
    }
}
