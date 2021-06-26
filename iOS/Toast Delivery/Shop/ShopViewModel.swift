import Foundation
import Combine

class ShopViewModel {
    @Published var selectedToast: ToastItem?
    
    private var bindings = Set<AnyCancellable>()
    
    init() {
        
    }
    
    lazy var cartViewModel: CartViewModel = {
        let viewModel = CartViewModel()
        $selectedToast
            .assign(to: \.toast, on: viewModel)
            .store(in: &bindings)
        
        viewModel.didTapPurchase.sink { [unowned self] _ in
        }
        .store(in: &bindings)
        
        return viewModel
    }()
    
    lazy var toastListViewModel: ToastListViewModel = {
        
        let viewModel = ToastListViewModel(items: .stub)
        
        viewModel
             .$selectedToast
             .assign(to: \.selectedToast, on: self)
             .store(in: &bindings)
         
         return viewModel
    }()
}
