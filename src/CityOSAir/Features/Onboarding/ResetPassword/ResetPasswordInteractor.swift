//
//  ResetPasswordInteractor.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 1/9/20.
//  Copyright © 2020 CityOS. All rights reserved.
//

import Foundation
import Alamofire

protocol ResetPasswordBusinessLogic {
  func forgotPasswordStart(_ email: String)
}

class ResetPasswordInteractor {
  var presenter: ResetPasswordPresentationLogic?
}

// MARK: - Business Logic
extension ResetPasswordInteractor: ResetPasswordBusinessLogic {

  func forgotPasswordStart(_ email: String) {
    let request = ForgotPasswordStartRequest(email: email)
    CityOS.shared.session.request(Router.forgotPasswordStart(request: request)).debugLog().validate().responseJSON { response in
      switch response.result {
      case .success(_):
        self.presenter?.presentAlert("Verification link has been sent to your email.")
      case .failure(let err):
        log.error(err)
        if let data = response.data {
          let decoder = JSONDecoder()
          decoder.keyDecodingStrategy = .convertFromSnakeCase
          do {
            let error = try decoder.decode(ApiErrorResponse.self, from: data)
            if let errorCode = error.errors.first?.errorCode {
              if errorCode == 1049 {
                self.presenter?.presentError(error.errors.first!.errorMessage)
              } else {
                self.presenter?.presentError("Could not find user with this email.")
              }
            }
          } catch {
            self.presenter?.presentError("Network error.")
          }
        } else {
          self.presenter?.presentError("Network error.")
        }
      }
    }

  }

}
