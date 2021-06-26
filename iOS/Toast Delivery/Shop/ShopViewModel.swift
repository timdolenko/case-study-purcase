import Foundation
import Combine

class ShopViewModel {
    @Published var selectedToast: ToastItem?
    var goToCardDetails = PassthroughSubject<Void, Never>()
    
    private var bindings = Set<AnyCancellable>()
    
    init() {}
    
    lazy var cartViewModel: CartViewModel = {
        let viewModel = CartViewModel()
        $selectedToast
            .assign(to: \.toast, on: viewModel)
            .store(in: &bindings)
        
        viewModel.didTapPurchase.receive(subscriber: AnySubscriber(goToCardDetails))
        
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
    
    func makeCardDetailsViewModel() -> CardDetailsViewModel {
        let vm = CardDetailsViewModel()
        
        vm.didTapDone
            .first()
            .compactMap { [weak self] in self?.selectedToast }
            .flatMap {
                env.checkoutService.checkout(toast: $0)
                    .catch { error -> AnyPublisher<CheckoutResponse, Never> in
                        Empty(completeImmediately: true)
                            .eraseToAnyPublisher()
                    }
            }
            .sink { v in
                print(v)
            }
            .store(in: &bindings)
        
        
        return vm
    }
}
