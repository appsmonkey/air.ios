//
//  Credentials.swift
//  CityOSAir
//
//  Created by Haris Kovacevic on 24/04/2019.
//  Copyright © 2019 CityOS. All rights reserved.
//

import Foundation

struct Credentials: Codable {
  var email: String
  var password: String?
  var social: Social?
}


struct Social: Codable {
  var id: String
  var token: String
  var type: String
}

struct ResetPassword: Codable {
  var email: String
  var password: String
  var code: String
}

struct ResetPasswordResponse: Codable {

}
