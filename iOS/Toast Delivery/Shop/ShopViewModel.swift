import Foundation
import Combine

class ShopViewModel {
    @Published var selectedToast: ToastItem?
}

class ToastListViewModel {
    @Published private(set) var selectedToast: ToastItem?
    
    var didSelectToast = PassthroughSubject<ToastItem?, Never>()
    
    init() {
        bind()
    }
    
    func bind() {
        didSelectToast
            .subscribe(on: RunLoop.main)
            .assign(to: &$selectedToast)
    }
}
