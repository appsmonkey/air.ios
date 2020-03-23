//
//  ResetPasswordPresenter.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 1/9/20.
//  Copyright © 2020 CityOS. All rights reserved.
//

import UIKit

protocol ResetPasswordPresentationLogic {
  func presentAlert(_ message: String)
  func presentError(_ error: String)
}

class ResetPasswordPresenter {
  weak var viewController: ResetPasswordDisplayLogic?
}

// MARK: - Presentation Logic
extension ResetPasswordPresenter: ResetPasswordPresentationLogic {
  
  func presentAlert(_ message: String) {
    viewController?.displayAlert(message)
  }
  
  func presentError(_ error: String) {
    viewController?.displayError(error)
  }
  
}

