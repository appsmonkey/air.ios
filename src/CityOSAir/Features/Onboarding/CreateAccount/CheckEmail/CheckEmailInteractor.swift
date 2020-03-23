//
//  CheckEmailInteractor.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 1/9/20.
//  Copyright © 2020 CityOS. All rights reserved.
//

import Foundation
import Alamofire

protocol CheckEmailBusinessLogic {
  func checkEmail(_ email: String)
}

class CheckEmailInteractor {
  var presenter: CheckEmailPresentationLogic?
}

// MARK: - Business Logic
extension CheckEmailInteractor: CheckEmailBusinessLogic {
  
  func checkEmail(_ email: String) {
    let request = CreateUserRequest(email: email)
    CityOS.shared.session.request(Router.register(request: request)).validate().responseObject {
      (result: Result<RegisterAccountResponse>, response: DataResponse<Any>) in
      switch result {
      case .success(let response):
        log.info("REGISTER: \(response)")
        self.presenter?.presentVerifyEmail()
      case .failure(let error):
        log.error(error)
        self.presenter?.presentError("Email already registered.")
      }
    }
  }
  
}
