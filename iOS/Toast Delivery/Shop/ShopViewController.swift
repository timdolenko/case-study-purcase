//
//  ShopViewController.swift
//  Toast Delivery
//

import UIKit
import Combine

// TODO: create a checkout with shopping cart item
class ShopViewController: UIViewController {
    
    var viewModel = ShopViewModel()
    weak var listVC: ToastListViewController!
    weak var cartVC: CartViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupListView()
        setupCartView()
        setupConstraints()

        listVC.didMove(toParent: self)
        cartVC.didMove(toParent: self)
    }
    
    private func setupListView() {
        listVC = addChildWithView(
            ToastListViewController(viewModel: viewModel.toastListViewModel)
        )
    }
    
    private func setupCartView() {
        cartVC = addChildWithView(
            CartViewController(viewModel: viewModel.cartViewModel)
        )
    }
    
    private func addChildWithView<VC: UIViewController>(_ vc: VC) -> VC {
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        addChild(vc)
        view.addSubview(vc.view)
        return vc
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            listVC.view.topAnchor.constraint(equalTo: view.topAnchor),
            listVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            listVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            cartVC.view.topAnchor.constraint(equalTo: listVC.view.bottomAnchor),
            cartVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cartVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cartVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
