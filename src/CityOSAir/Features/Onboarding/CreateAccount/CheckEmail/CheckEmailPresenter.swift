//
//  CheckEmailPresenterr.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 1/9/20.
//  Copyright © 2020 CityOS. All rights reserved.
//

import UIKit

protocol CheckEmailPresentationLogic {
  func presentError(_ error: String)
  func presentVerifyEmail()
}

class CheckEmailPresenter {
  weak var viewController: CheckEmailDisplayLogic?
}

// MARK: - Presentation Logic
extension CheckEmailPresenter: CheckEmailPresentationLogic {
  func presentError(_ error: String) {
    viewController?.displayError(error)
  }
  
  func presentVerifyEmail() {
    viewController?.displayVerifyEmail()
  }
}

