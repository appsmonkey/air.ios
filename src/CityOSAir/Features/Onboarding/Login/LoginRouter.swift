//
//  LoginWireframe.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 11/28/19.
//  Copyright (c) 2019 CityOS. All rights reserved.
//

import UIKit

protocol LoginRoutingLogic {
  func presentWelcomeScreen()
  func presentMainScreen()
  func presentSignUp()
  func presentForgotPassword()
  func navigateToAlert(title: String, message: String, handler: (() -> Void)?)
  func dismis()
}

protocol LoginRouterDelegate: class {
  func loggedInFromSideMenu()
}

class LoginRouter {
  weak var viewController: LoginViewController?
  weak var delegate: LoginRouterDelegate?
}

// MARK: - Routing Logic
extension LoginRouter: LoginRoutingLogic {
  func presentWelcomeScreen() {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    let welcomeViewControllerr = WelcomeViewController()
    let navigationViewController = UINavigationController(rootViewController: welcomeViewControllerr)
    appDelegate.window?.rootViewController = navigationViewController
  }
  
  func presentMainScreen() {
    let deviceViewController = MainViewController(delegate: nil)
    deviceViewController.modalPresentationStyle = .fullScreen
    
    let slideMenuViewController = SlideMenuController(mainViewController: deviceViewController, leftMenuViewController: MenuViewController())
    slideMenuViewController.modalPresentationStyle = .fullScreen
    SlideMenuOptions.contentViewScale = 1
    SlideMenuOptions.hideStatusBar = false
    
    viewController?.present(slideMenuViewController, animated: true, completion: nil)
  }
  
  func presentSignUp() {
    viewController?.navigationController?.pushViewController(CheckEmailViewController(delegate: nil), animated: true)
  }
  
  func presentForgotPassword() {
    viewController?.navigationController?.pushViewController(ResetPasswordViewController(delegate: nil), animated: true)
  }
  
  func navigateToAlert(title: String, message: String, handler: (() -> Void)?) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "general_ok".localized(), style: .cancel, handler: { _ in handler?() }))
    viewController?.present(alert, animated: true, completion: nil)
  }
  
  func dismis() {
    viewController?.dismiss(animated: true, completion: nil)
  }
}
