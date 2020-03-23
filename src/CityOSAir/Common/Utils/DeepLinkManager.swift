//
//  DeepLinkManager.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 1/15/20.
//  Copyright © 2020 CityOS. All rights reserved.
//

import UIKit
import Alamofire

enum ScreenName: Int {
  case validate = 0
}

class DeeplinkManager {
  let supportedPaths: [String: ScreenName]
  static let sharedInstance = DeeplinkManager()

  private init() {
    supportedPaths = ["/auth/validate": ScreenName.validate]
  }

  func handleUniversalLink(with url: URL, components: URLComponents, window: UIWindow) -> Bool {
    guard let screenName = findScreenName(forDeeplink: url) else {
      presentErrorScreen()
      return false
    }

    navigateToScreen(with: screenName, url: url, components: components, window: window)

    return true
  }

  func findScreenName(forDeeplink deeplink: URL) -> ScreenName? {
    for (screenPath, screenName) in supportedPaths {
      if deeplink.absoluteString.contains(screenPath) {
        return screenName
      }
    }
    return nil
  }

  func navigateToScreen(with screenName: ScreenName, url: URL, components: URLComponents, window: UIWindow) {
    switch screenName {
    case .validate:
      showSignUpScreen(with: url, components: components, window: window)
    }
  }

  func showSignUpScreen(with url: URL, components: URLComponents, window: UIWindow) {
    guard let queryItems = components.queryItems else { return }
    guard let clientId = queryItems[0].value,
      let userName = queryItems[1].value,
      let confirmationCode = queryItems[2].value,
      let type = queryItems[3].value,
      let cogId = queryItems[4].value else { return }
    let request = VerifyEmailRequest(clientId: clientId, userName: userName, confirmationCode: confirmationCode, type: type, cogId: cogId)
    // if deep link type is verify it's a signup flow navigate sign up screen
    if type == "verify" {
      CityOS.shared.session.request(Router.validate(request: request)).validate().responseObject {
        (result: Result<ValidateEmailResponse>, response: DataResponse<Any>) in
        switch result {
        case .success(let response):
          self.presentSignUpScreen(window: window, email: response.data.email, token: response.data.token, cognitoId: response.data.cognitoId)
        case .failure(let error):
          log.error(error)
          self.presentErrorScreen()
        }
      }
    }
    // otherwise it's password reset flow and navigate to reset password screen
    else if type == "pwreset" {
      CityOS.shared.session.request(Router.validate(request: request)).validate().responseObject {
        (result: Result<ValidateEmailResponse>, response: DataResponse<Any>) in
        switch result {
        case .success(let response):
          self.navigateToResetPasswordScreen(window: window, email: userName, token: response.data.token, cognitoId: response.data.cognitoId)
        case .failure(let error):
          log.error(error)
          self.presentErrorScreen()
        }
      }
    }
  }

  func navigateToResetPasswordScreen(window: UIWindow, email: String, token: String, cognitoId: String) {
    let changePasswordViewController = ChangePasswordViewController(delegate: nil)
    changePasswordViewController.email = email
    changePasswordViewController.token = token
    changePasswordViewController.cognitoId = cognitoId
    let navigationController = UINavigationController(rootViewController: changePasswordViewController)
    navigationController.modalPresentationStyle = .fullScreen
    navigationController.interactivePopGestureRecognizer?.isEnabled = false
    window.rootViewController = navigationController
  }

  func presentSignUpScreen(window: UIWindow, email: String, token: String, cognitoId: String) {
    guard !email.isEmpty && !token.isEmpty && !cognitoId.isEmpty else {
      presentErrorScreen()
      return
    }
    let signupViewController = SignUpViewController(delegate: nil)
    signupViewController.email = email
    signupViewController.token = token
    signupViewController.cognitoId = cognitoId
    let navigationController = UINavigationController(rootViewController: signupViewController)
    navigationController.modalPresentationStyle = .fullScreen
    navigationController.interactivePopGestureRecognizer?.isEnabled = false
    window.rootViewController = navigationController
  }

  func presentErrorScreen() {
    let alert = UIAlertController(title: "Error", message: "Error while validating email.", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "general_ok".localized(), style: .cancel, handler: nil))
    UIApplication.topViewController()?.present(alert, animated: false, completion: nil)
  }
}

extension UIApplication {
  class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
    if let tabController = controller as? UITabBarController {
      return topViewController(controller: tabController.selectedViewController)
    }
    if let navController = controller as? UINavigationController {
      return topViewController(controller: navController.visibleViewController)
    }
    if let presented = controller?.presentedViewController {
      return topViewController(controller: presented)
    }
    return controller
  }
}
