//
//  SceneDelegate.swift
//  ATMs
//
//  Created by Karina Kovaleva on 26.12.22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = UINavigationController(rootViewController: MainViewController())
        window.makeKeyAndVisible()
        self.window = window
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        LocationManager.shared.checkAuthorizationStatus()
        if LocationManager.shared.isAllowed == .denied ||
            LocationManager.shared.isAllowed == .restricted {
            let alert = UIAlertController(title: "Карты не знают, где вы находитесь",
                                          message: """
                                                   Разрешите им определять Ваше местоположение:
                                                   это делается в настройках устройства.
                                                   """,
                                          preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Отменить", style: .cancel)
            alert.addAction(cancel)
            if let settings = URL(string: UIApplication.openSettingsURLString),
               UIApplication.shared.canOpenURL(settings) {
                alert.addAction(UIAlertAction(title: "Настройки", style: .default) { _ in
                    UIApplication.shared.open(settings)
                })
            }
            self.window?.rootViewController?.present(alert, animated: true)
        } else if LocationManager.shared.isAllowed == .authorizedWhenInUse {
            NotificationCenter.default.post(name: Notification.Name("locationAccessed"),
                                            object: nil,
                                            userInfo: nil)
        }
    }
}
