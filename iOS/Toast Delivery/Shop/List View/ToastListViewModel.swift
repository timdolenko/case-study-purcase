//
//  ToastListViewModel.swift
//  Toast Delivery
//

import Foundation
import Combine
import CoreTools

class ToastListViewModel {
    @Published var items: [ToastItem]
    @Published private(set) var selectedToast: ToastItem?
    
    var didSelectItemAtIndex = PassthroughSubject<Int, Never>()
    
    init(items: [ToastItem]) {
        self.items = items
        bind()
    }
    
    func bind() {
        didSelectItemAtIndex
            .compactMap { [unowned self] index in
                items[safe: index]
            }
            .subscribe(on: RunLoop.main)
            .assign(to: &$selectedToast)
    }
}

