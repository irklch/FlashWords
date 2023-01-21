//
//  SceneDelegate.swift
//  FlashWords
//
//  Created by Ирина Кольчугина on 14.12.2022.
//

import UIKit
import SwiftExtension

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let viewController = UINavigationController()
        let folders = StorageManager.getFoldersItemsFromLocalStorage()
        let viewControllers: [UIViewController] = Ternary.get(
            if: .value((folders.count == 0).or(folders.first(where: { $0.isSelected }) == nil)),
            true: .value([FoldersTableVC()]),
            false: .value([FoldersTableVC(), WordListTableVC()]))
        viewController.viewControllers = viewControllers
        UIBarButtonItem.appearance().setTitleTextAttributes(
            [NSAttributedString.Key.font: UIFont.avenirMedium18], for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes(
            [NSAttributedString.Key.font: UIFont.avenirMedium18], for: .highlighted)
        UIBarButtonItem.appearance().setTitleTextAttributes(
            [NSAttributedString.Key.font: UIFont.avenirMedium18], for: .focused)
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }
}

