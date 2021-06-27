import Foundation
import Combine

class ShopViewModel {
    @Published var selectedToast: ToastItem?
    var checkout: CheckoutResponse?
    
    var goToCardDetails = PassthroughSubject<Void, Never>()
    var result = PassthroughSubject<PaymentResult, Never>()
    var failure = PassthroughSubject<Error, Never>()
    
    private var bindings = Set<AnyCancellable>()
    
    init() {
        bind()
    }
    
    func bind() {
        goToCardDetails
            .compactMap { [weak self] in self?.selectedToast }
            .flatMap {
                env.checkoutService.createCheckout(toast: $0)
            }
            .catch({ [weak self] error -> AnyPublisher<CheckoutResponse, Never> in
                self?.failure.send(error)
                return Empty<CheckoutResponse, Never>(completeImmediately: true)
                    .eraseToAnyPublisher()
            })
            .map { response -> CheckoutResponse? in response }
            .assign(to: \.checkout, on: self)
            .store(in: &bindings)
        
        $selectedToast
            .map { toast -> CheckoutResponse? in nil }
            .assign(to: \.checkout, on: self)
            .store(in: &bindings)
    }
    
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
    
    func makeCardDetailsViewModel() -> CardDetailsViewModel? {
        guard let toast = selectedToast else { return nil }
        return CardDetailsViewModel(toast: toast)
    }
}
