//
//  CartViewModel.swift
//  Toast Delivery
//

import Combine

fileprivate struct Placeholders {
    var toastName: String = "<Selected Toast>"
    var price: String = "<Price>"
}

fileprivate var placeholders = Placeholders()

class CartViewModel {
    @Published var toast: ToastItem?
    var didTapPurchase = PassthroughSubject<Void, Never>()
    
    @Published var toastName: String? = placeholders.toastName
    @Published var toastPrice: String? = placeholders.price
    
    init() {
        bind()
    }
    
    func bind() {
        let toast = $toast
            .share()
            
        toast
            .map { $0?.name ?? placeholders.toastName }
            .assign(to: &$toastName)
        
        toast
            .map {
                guard let toast = $0 else { return placeholders.price }

                return env.currencyService.format(price: toast.price)
            }
            .assign(to: &$toastPrice)
    }
}
