import Foundation

protocol CurrencyFormatService {
    var currency: String { get }
    func format(price: NSDecimalNumber) -> String
}

class CurrencyFormatServiceLive: CurrencyFormatService {
    
    private let formatter = NumberFormatter()
    
    init() {
        setupFormatter()
    }
    
    private func setupFormatter() {
        formatter.numberStyle = .currency
        formatter.locale = .autoupdatingCurrent
    }
    
    func format(price: NSDecimalNumber) -> String {
        formatter.string(for: price) ?? ""
    }
    
    var currency: String {
        formatter.currencyCode
    }
}
