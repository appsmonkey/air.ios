//
//  LoginResponse.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 12/3/19.
//  Copyright © 2019 CityOS. All rights reserved.
//

import Foundation

struct LoginResponse: Codable {
  let requestId: String
  let code: Int
  let errors: String?
  let data: Data
  
  struct Data: Codable {
    let idToken: String
    let accessToken: String
    let expiresIn: Int
    let refreshToken: String
  }
}
