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
        
        setupGoToCardDetails()
    }
    
    
    // Note: should be move to Coordinator
    private func setupGoToCardDetails() {
//        viewModel.goToCardDetails.sink { [unowned self] _ in
//            let vc = CardViewController()
//            vc.viewModel = viewModel.makeCardDetailsViewModel()
//
//            present(vc, animated: true, completion: nil)
//        }
//        .store(in: &bindings)
        
        viewModel
            .goToCardDetails
            .compactMap { [weak self] in self?.viewModel.selectedToast }
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
