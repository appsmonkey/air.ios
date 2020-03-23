//
//  SignUpPresenter.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 12/1/19.
//  Copyright © 2019 CityOS. All rights reserved.
//

import UIKit

protocol SignUpPresentationLogic {
  func presentSignUpError(_ error: Error)
  func presentHome()
}

class SignUpPresenter {
  weak var viewController: SignUpDisplayLogic?
}

// MARK: - Presentation Logic
extension SignUpPresenter: SignUpPresentationLogic {
  func presentSignUpError(_ error: Error) {
    viewController?.displayError(error)
  }
  
  func presentHome() {
    viewController?.displayLogin()
  }
}
