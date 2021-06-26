//
//  CartViewController.swift
//  Toast Delivery
//

import UIKit
import Combine
import CoreUI

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
        viewModel
            .$toastName
            .assign(to: \.text, on: toastNameLabel)
            .store(in: &bindings)
        
        viewModel
            .$toastPrice
            .assign(to: \.text, on: toastPriceLabel)
            .store(in: &bindings)
        
        purchaseButton
            .publisher(for: .touchUpInside)
            .map { _ in () }
            .receive(subscriber: AnySubscriber(viewModel.didTapPurchase))
    }
}
