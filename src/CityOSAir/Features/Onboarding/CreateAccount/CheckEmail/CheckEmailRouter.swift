//
//  CheckEmailRouter.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 1/9/20.
//  Copyright © 2020 CityOS. All rights reserved.
//

import UIKit

protocol CheckEmailRoutingLogic {
  func navigateToSignUpScreen(email: String)
  func navigateToAlert(title: String, message: String, handler: (() -> Void)?)
}

protocol CheckEmailRouterDelegate: class {
  
}

class CheckEmailRouter {
  weak var viewController: CheckEmailViewController?
  weak var delegate: CheckEmailRouterDelegate?
}

// MARK: - Routing Logic
extension CheckEmailRouter: CheckEmailRoutingLogic {
  
  func navigateToSignUpScreen(email: String) {
    let verifyEmailViewController = VerifyEmailViewController()
    verifyEmailViewController.email = email
    viewController?.navigationController?.pushViewController(verifyEmailViewController, animated: true)
  }
  
  func navigateToAlert(title: String, message: String, handler: (() -> Void)?) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "general_ok".localized(), style: .cancel, handler: { _ in handler?() }))
    viewController?.present(alert, animated: true, completion: nil)
  }
  
}

