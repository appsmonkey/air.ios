//
//  RefreshTokenResponse.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 12/23/19.
//  Copyright © 2019 CityOS. All rights reserved.
//

import Foundation

struct RefreshTokenResponse: Codable {
  let code: Int
  let errors: String?
  let requestId: String
  let data: Data
  
  struct Data: Codable {
    let idToken: String
    let accessToken: String
    let expiresIn: Int
  }
}
