//
//  UIViewContollerExtensions.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 11/28/19.
//  Copyright © 2019 CityOS. All rights reserved.
//

import UIKit

extension UIViewController {

  func hideKeyboardWhenTappedAround() {
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
    view.addGestureRecognizer(tap)
  }

  @objc func dismissKeyboard() {
    view.endEditing(true)
  }

  func alert(_ title: String, message: String?, close: String, closeHandler: ((UIAlertAction) -> Void)?) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: close, style: .cancel, handler: closeHandler))
    present(alert, animated: true, completion: nil)
  }

  func darkView() -> UIView {
    let darkView = UIView(frame: UIScreen.main.bounds)
    darkView.tag = 123
    darkView.backgroundColor = UIColor.black.withAlphaComponent(0.7)

    UIApplication.shared.keyWindow?.addSubview(darkView)

    return darkView
  }
}
