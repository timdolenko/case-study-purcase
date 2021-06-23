//
//  ToastItem.swift
//  Toast Delivery
//

import Foundation
import UIKit

struct ToastItem: Decodable, Hashable {
    let name: String
    private let priceString: String
    private let imageName: String

    var price: NSDecimalNumber {
        return NSDecimalNumber(string: priceString)
    }

    var image: UIImage? {
        return UIImage(named: imageName)
    }

    enum CodingKeys: String, CodingKey {
        case name
        case priceString = "price"
        case imageName = "image_name"
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}
