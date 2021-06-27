//
//  CartViewModel.swift
//  Toast Delivery
//

import Combine

fileprivate var translations: Translations.Cart {
    env.translations.cart
}

class CartViewModel {
    @Published var toast: ToastItem?
    var didTapPurchase = PassthroughSubject<Void, Never>()
    
    @Published var toastName: String? = translations.toastName
    @Published var toastPrice: String? = translations.price
    
    init() {
        bind()
    }
    
    func bind() {
        let toast = $toast
            .share()
            
        toast
            .map { $0?.name ?? translations.toastName }
            .assign(to: &$toastName)
        
        toast
            .map {
                guard let toast = $0 else { return translations.price }

                return env.currencyService.format(price: toast.price)
            }
            .assign(to: &$toastPrice)
    }
}
