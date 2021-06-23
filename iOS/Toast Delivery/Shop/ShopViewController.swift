//
//  ShopViewController.swift
//  Toast Delivery
//

import UIKit

// TODO: create a checkout with shopping cart item
class ShopViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let listVC = createToastList()!
        listVC.view.translatesAutoresizingMaskIntoConstraints = false
        addChild(listVC)
        view.addSubview(listVC.view)

        let cartVC = CartViewController()
        cartVC.view.translatesAutoresizingMaskIntoConstraints = false
        addChild(cartVC)
        view.addSubview(cartVC.view)

        NSLayoutConstraint.activate([
            listVC.view.topAnchor.constraint(equalTo: view.topAnchor),
            listVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            listVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            cartVC.view.topAnchor.constraint(equalTo: listVC.view.bottomAnchor),
            cartVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cartVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cartVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        listVC.didMove(toParent: self)
        cartVC.didMove(toParent: self)
    }

    private func createToastList() -> ToastListViewController? {
        guard let url = Bundle.main.url(forResource: "toasts", withExtension: "json") else {
            return nil
        }

        return ToastListViewController(contentsOfURL: url)
    }

}
