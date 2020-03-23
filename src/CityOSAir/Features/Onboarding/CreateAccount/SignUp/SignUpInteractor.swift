//
//  SignUpInteractor.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 12/1/19.
//  Copyright © 2019 CityOS. All rights reserved.
//

import Alamofire

protocol SignUpBusinessLogic {
  func register(email: String, password: String, token: String, cognitoId: String, profile: UserProfile)
}

class SignUpInteractor {
  var presenter: SignUpPresentationLogic?
}

// MARK: - Business Logic
extension SignUpInteractor: SignUpBusinessLogic {
  func register(email: String, password: String, token: String, cognitoId: String, profile: UserProfile) {
    let userProfile = UserProfile(firstName: profile.firstName ?? "", lastName: profile.lastName ?? "", bio: profile.bio ?? "",
                                  city: profile.city ?? "", gender: profile.gender ?? "", birthday: profile.birthday ?? -1)
    let signUpRequest = SignUpRequest(userProfile: userProfile, token: token, cognitoId: cognitoId, userName: email, password: password)
    CityOS.shared.session.request(Router.signUp(request: signUpRequest)).validate().responseObject {
      (result: Result<SignUpResponse>, response: DataResponse<Any>) in
      switch result {
      case .success(_):
        self.presenter?.presentHome()
      case .failure(let error):
        log.error(error)
        self.presenter?.presentSignUpError(error)
      }
    }
  }
}

