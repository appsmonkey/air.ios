//
//  SignUpRequest.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 12/4/19.
//  Copyright © 2019 CityOS. All rights reserved.
//

import Foundation

struct SignUpRequest: Codable {
  let userProfile: UserProfile
  let token: String
  let cognitoId: String
  let userName: String
  let password: String
  
  private enum CodingKeys: String, CodingKey {
    case userProfile = "user_profile"
    case token
    case cognitoId = "cognito_id"
    case userName = "user_name"
    case password
  }
}
