//
//  Assembly.swift
//  Toast Delivery
//

import DITranquillity

protocol Assembly {
    var container: DIContainer { get }
}
extension Assembly {
    func resolve<T>() -> T {
        container.resolve()
    }
}
