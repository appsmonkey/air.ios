//
//  LoginPresenter.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 11/28/19.
//  Copyright (c) 2019 CityOS. All rights reserved.
//

import UIKit

protocol LoginPresentationLogic {
  func presentLoginError(_ error: NetworkError)
  func presentMainController()
}

class LoginPresenter {
  weak var viewController: LoginDisplayLogic?
}

// MARK: - Presentation Logic
extension LoginPresenter: LoginPresentationLogic {
  func presentLoginError(_ error: NetworkError) {
    viewController?.displayError(error)
  }
  
  func presentMainController() {
    viewController?.displayMainController()
  }
}
