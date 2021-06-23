//
//  CartViewController.swift
//  Toast Delivery
//

import UIKit

class CartViewController: UIViewController {

    @IBOutlet
    weak var toastNameLabel: UILabel?
    @IBOutlet
    weak var toastPriceLabel: UILabel?

    init() {
        super.init(nibName: "CartViewController", bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

}
