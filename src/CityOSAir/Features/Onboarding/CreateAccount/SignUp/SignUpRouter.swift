//
//  SignUpRouter.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 12/1/19.
//  Copyright © 2019 CityOS. All rights reserved.
//

import UIKit

protocol SignUpRoutingLogic {
  func navigateToLoginScreen(email: String, password: String)
  func navigateToAlert(title: String, message: String, handler: (() -> Void)?)
}

protocol SignUpRouterDelegate: class {
  
}

class SignUpRouter {
  weak var viewController: SignUpViewController?
  weak var delegate: SignUpRouterDelegate?
}

// MARK: - Routing Logic
extension SignUpRouter: SignUpRoutingLogic {
  func navigateToLoginScreen(email: String, password: String) {
    if let window = UIApplication.shared.keyWindow {
      UIView.transition(with: window, duration: 0.6, options: .transitionFlipFromLeft, animations: {
        let loginViewController = LoginViewController(delegate: nil, isDeepLink: true, email: email, password: password)
        loginViewController.email = email
        loginViewController.password = password
        let navigationController = UINavigationController(rootViewController: loginViewController)
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.interactivePopGestureRecognizer?.isEnabled = false
        window.rootViewController = navigationController
      }, completion: nil)
    } else {
      viewController?.dismiss(animated: true, completion: nil)
    }
  }
  
  func navigateToAlert(title: String, message: String, handler: (() -> Void)?) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "general_ok".localized(), style: .cancel, handler: { _ in handler?() }))
    viewController?.present(alert, animated: true, completion: nil)
  }
}

