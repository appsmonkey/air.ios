//
//  ChangePasswordInteractor.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 1/9/20.
//  Copyright © 2020 CityOS. All rights reserved.
//

import Foundation
import Alamofire

protocol ChangePasswordBusinessLogic {
  func forgotPasswordEnd(email: String, password: String, token: String, cognitoId: String)
}

class ChangePasswordInteractor {
  var presenter: ChangePasswordPresentationLogic?
}

// MARK: - Business Logic
extension ChangePasswordInteractor: ChangePasswordBusinessLogic {
  
  func forgotPasswordEnd(email: String, password: String, token: String, cognitoId: String) {
    let request = ForgotPasswordEndRequest(email: email, password: password, token: token, cognitoId: cognitoId)
    CityOS.shared.session.request(Router.forgotPasswordEnd(request: request)).debugLog().validate().responseJSON { response in
      switch response.result {
      case .success(let response):
        log.info(response)
        self.presenter?.presentWelcomeScreen()
      case .failure(let error):
        log.error(error)
        self.presenter?.presentError("Failed to reset the password. Unkown error.")
      }
    }
  }
  
}

