//
//  ToastItems+Stub.swift
//  Toast Delivery
//

import Foundation

extension Array where Element == ToastItem {
    static var stub: Self {
        guard let url = Bundle.main.url(forResource: "toasts", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let items = try? JSONDecoder().decode([ToastItem].self, from: data) else {
            fatalError("toasts.json is missing")
        }
        return items
    }
}
