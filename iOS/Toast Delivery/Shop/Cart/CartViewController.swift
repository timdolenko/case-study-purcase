//
//  CartViewController.swift
//  Toast Delivery
//

import UIKit
import Combine

fileprivate struct Placeholders {
    var toastName: String = "<Selected Toast>"
    var price: String = "<Price>"
}

fileprivate var placeholders = Placeholders()

class CartViewController: UIViewController {
    
    @Published var toast: ToastItem?
    
    private var bindings = Set<AnyCancellable>()

    @IBOutlet
    weak var toastNameLabel: UILabel!
    @IBOutlet
    weak var toastPriceLabel: UILabel!

    init() {
        super.init(nibName: "CartViewController", bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    private func bind() {
        let toast = $toast
            .share()
            
        toast
            .map { $0?.name ?? placeholders.toastName }
            .assign(to: \.text, on: toastNameLabel)
            .store(in: &bindings)
        
        toast
            .map {
                guard let toast = $0 else { return placeholders.price }
                
                return env.currencyService.format(price: toast.price)
            }
            .assign(to: \.text, on: toastPriceLabel)
            .store(in: &bindings)
    }
}
