//
//  ValidateUserRequest.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 1/16/20.
//  Copyright © 2020 CityOS. All rights reserved.
//

import Foundation

struct VerifyEmailRequest: Codable {
  let clientId: String
  let userName: String
  let confirmationCode: String
  let type: String
  let cogId: String
}
