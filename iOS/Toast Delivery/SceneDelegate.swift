//
//  SceneDelegate.swift
//  Toast Delivery
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        window = UIWindow()
        window?.windowScene = scene as? UIWindowScene
        window?.rootViewController = ShopViewController()
        window?.makeKeyAndVisible()
    }
}
