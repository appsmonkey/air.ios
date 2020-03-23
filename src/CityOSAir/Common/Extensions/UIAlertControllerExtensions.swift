//
//  UIAlertControllerExtensions.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 11/28/19.
//  Copyright © 2019 CityOS. All rights reserved.
//

import UIKit

extension UIAlertController {
  func show() {
    let win = UIWindow(frame: UIScreen.main.bounds)
    let vc = UIViewController()
    vc.view.backgroundColor = .clear
    win.rootViewController = vc
    win.windowLevel = UIWindow.Level.alert + 1
    win.makeKeyAndVisible()
    vc.present(self, animated: true, completion: nil)
  }
  func hide() {
    self.presentingViewController?.dismiss(animated: true, completion: nil)
  }

}

extension UIAlertController {
  class func basicAlert(message: String) -> UIAlertController {
    let alertController = UIAlertController(title: "CityOS", message: message, preferredStyle: .alert)
    let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
    alertController.addAction(action)
    return alertController
  }

  class func basicAlert(message: String, completion: @escaping () -> Void) -> UIAlertController {
    let alertController = UIAlertController(title: "CityOS", message: message, preferredStyle: .alert)
    let action = UIAlertAction(title: "Ok", style: .default) { (_) in
      completion()
    }
    alertController.addAction(action)
    return alertController
  }

  class func cancelAlert(title: String, message: String, confirmButtonTitle: String, confirmClosure: @escaping () -> Void) -> UIAlertController {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let action = UIAlertAction(title: confirmButtonTitle, style: .default) { (_) in
      confirmClosure()
    }

    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    alertController.addAction(action)
    alertController.addAction(cancelAction)
    return alertController
  }
}

