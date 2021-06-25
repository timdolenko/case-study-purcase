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
    private var bindings = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupListView()
        setupCartView()
        setupConstraints()

        listVC.didMove(toParent: self)
        cartVC.didMove(toParent: self)
        
        bind()
    }
    
    private func setupListView() {
        let listVC = createToastList()!
        listVC.view.translatesAutoresizingMaskIntoConstraints = false
        addChild(listVC)
        view.addSubview(listVC.view)
        self.listVC = listVC
    }
    
    private func setupCartView() {
        let cartVC = CartViewController()
        cartVC.view.translatesAutoresizingMaskIntoConstraints = false
        addChild(cartVC)
        view.addSubview(cartVC.view)
        self.cartVC = cartVC
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
    
    private func bind() {
        bindListView()
        bindCartView()
    }
    
    private func bindListView() {
        let viewModel = ToastListViewModel()
        viewModel
            .$selectedToast
            .assign(to: \.selectedToast, on: self.viewModel)
            .store(in: &bindings)
        
        listVC.viewModel = viewModel
    }
    
    private func bindCartView() {
        viewModel
            .$selectedToast
            .assign(to: \.toast, on: cartVC)
            .store(in: &bindings)
    }

    private func createToastList() -> ToastListViewController? {
        guard let url = Bundle.main.url(forResource: "toasts", withExtension: "json") else {
            return nil
        }

        return ToastListViewController(contentsOfURL: url)
    }

}
