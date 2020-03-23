//
//  ForgotPasswordStartRequest.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 1/9/20.
//  Copyright © 2020 CityOS. All rights reserved.
//

import Foundation

struct ForgotPasswordEndRequest: Codable {
  let email: String
  let password: String
  let token: String
  let cognitoId: String
  
  private enum CodingKeys: String, CodingKey {
    case email
    case password
    case token
    case cognitoId = "cognito_id"
  }
}
