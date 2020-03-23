//
//  ChangePasswordPresenter.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 1/9/20.
//  Copyright © 2020 CityOS. All rights reserved.
//

import UIKit

protocol ChangePasswordPresentationLogic {
  func presentError(_ error: String)
  func presentWelcomeScreen()
}

class ChangePasswordPresenter {
  weak var viewController: ChangePasswordDisplayLogic?
}

// MARK: - Presentation Logic
extension ChangePasswordPresenter: ChangePasswordPresentationLogic {
  func presentError(_ error: String) {
    viewController?.displayError(error)
  }
  
  func presentWelcomeScreen() {
    viewController?.displayWelcomeScreen()
  }
}

