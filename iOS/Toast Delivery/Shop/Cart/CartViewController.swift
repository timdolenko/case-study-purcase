//
//  CartViewController.swift
//  Toast Delivery
//

import UIKit
import Combine
import CoreUI
import CoreTools

class CartViewController: UIViewController {
    
    @IBOutlet
    weak var toastNameLabel: UILabel!
    @IBOutlet
    weak var toastPriceLabel: UILabel!
    @IBOutlet
    weak var purchaseButton: UIButton!
    
    let viewModel: CartViewModel
    
    private var bindings = Set<AnyCancellable>()

    init(viewModel: CartViewModel) {
        self.viewModel = viewModel
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
        bindings.collect {
            viewModel
                .$toastName
                .assign(to: \.text, on: toastNameLabel)
            
            viewModel
                .$toastPrice
                .assign(to: \.text, on: toastPriceLabel)
            
            viewModel
                .$toast
                .map { $0 != nil }
                .assign(to: \.isEnabled, on: purchaseButton)
            
            viewModel
                .$toast
                .map { $0 != nil ? 1.0 : 0.3 }
                .assign(to: \.alpha, on: purchaseButton)
        }
        
        purchaseButton
            .publisher(for: .touchUpInside)
            .map { _ in () }
            .receive(subscriber: AnySubscriber(viewModel.didTapPurchase))
    }
}
