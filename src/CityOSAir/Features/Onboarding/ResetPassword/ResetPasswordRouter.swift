//
//  ResetPasswordRouter.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 1/9/20.
//  Copyright © 2020 CityOS. All rights reserved.
//

import UIKit

protocol ResetPasswordRoutingLogic {
  func navigateToSignUpScreen()
  func navigateToAlert(title: String, message: String, handler: (() -> Void)?)
}

protocol ResetPasswordRouterDelegate: class {
  
}

class ResetPasswordRouter {
  weak var viewController: ResetPasswordViewController?
  weak var delegate: ResetPasswordRouterDelegate?
}

// MARK: - Routing Logic
extension ResetPasswordRouter: ResetPasswordRoutingLogic {
  
  func navigateToSignUpScreen() {
    let signUpViewController = SignUpViewController(delegate: nil)
    viewController?.navigationController?.pushViewController(signUpViewController, animated: true)
  }
  
  func navigateToAlert(title: String, message: String, handler: (() -> Void)?) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "general_ok".localized(), style: .cancel, handler: { _ in handler?() }))
    viewController?.present(alert, animated: true, completion: nil)
  }
  
}
