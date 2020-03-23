//
//  RegisterAccountResponse.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 1/16/20.
//  Copyright © 2020 CityOS. All rights reserved.
//

import Foundation

struct RegisterAccountResponse: Codable {
  let requestId: String
  let code: Int
  let errors: String?
  // let userGroups: String?
  let data: Data
  
  struct Data: Codable {
    let idToken: String
    let accessToken: String
    let expiresIn: Int
  }
}
