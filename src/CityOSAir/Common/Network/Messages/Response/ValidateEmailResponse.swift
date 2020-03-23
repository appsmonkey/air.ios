//
//  ValidateEmailResponse.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 1/16/20.
//  Copyright © 2020 CityOS. All rights reserved.
//

import Foundation

struct ValidateEmailResponse: Codable {
  let requestId: String
  let code: Int
  let errors: String?
  let data: Data
  
  struct Data: Codable {
    let email: String
    let cognitoId: String
    let groupId: String
    let isGroup: Bool
    let token: String
  }
}
