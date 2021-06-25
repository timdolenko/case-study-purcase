//
//  CartViewController.swift
//  Toast Delivery
//

import UIKit
import Combine

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
        $toast
            .map { $0?.name }
            .assign(to: \.text, on: toastNameLabel)
            .store(in: &bindings)
    }
}
