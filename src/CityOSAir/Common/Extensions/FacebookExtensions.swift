//
//  FacebookExtensions.swift
//  CityOSAir
//
//  Created by Haris Kovacevic on 17/06/2019.
//  Copyright © 2019 CityOS. All rights reserved.
//

import Foundation

import UIKit
import FBSDKLoginKit

struct FacebookLoginResult {
  var success: Bool
  var id: String?
  var token: String?
  var email: String?
  var name: String?
  var birthday: String?
}

extension LoginManager {
  func login(viewController: UIViewController, completetion: @escaping(_ result: FacebookLoginResult) -> Void) {
    logIn(permissions: ["email", "public_profile", "user_birthday"], from: viewController) { result, error in
      if let token = result?.token {
        let request = GraphRequest(graphPath: "/me",
          parameters: ["fields": "id, name, email , birthday"],
          httpMethod: .get)
        request.start { _, profileResult, error in
          if let profile = (profileResult as? NSDictionary),
            let id = profile["id"] as? String,
            let email = profile["email"] as? String {
            let res = FacebookLoginResult(success: true, id: id, token: token.tokenString, email: email, name: nil, birthday: nil)
            completetion(res)
          }
        }
      } else {
        completetion(FacebookLoginResult(success: false, id: nil, token: nil, email: nil, name: nil, birthday: nil))
      }
    }
  }
}
