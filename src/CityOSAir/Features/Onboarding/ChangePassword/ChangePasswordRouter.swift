//
//  ChangePasswordRouter.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 1/9/20.
//  Copyright © 2020 CityOS. All rights reserved.
//

import UIKit

protocol ChangePasswordRoutingLogic {
  func navigateToWelcomeScreen()
  func navigateToAlert(title: String, message: String, handler: (() -> Void)?)
}

protocol ChangePasswordRouterDelegate: class {
  
}

class ChangePasswordRouter {
  weak var viewController: ChangePasswordViewController?
  weak var delegate: ChangePasswordRouterDelegate?
}

// MARK: - Routing Logic
extension ChangePasswordRouter: ChangePasswordRoutingLogic {
  
  func navigateToWelcomeScreen() {
    if let window = UIApplication.shared.keyWindow {
      UIView.transition(with: window, duration: 0.6, options: .transitionFlipFromLeft, animations: {
          let navigationController = UINavigationController(rootViewController: LoginViewController(delegate: nil))
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
