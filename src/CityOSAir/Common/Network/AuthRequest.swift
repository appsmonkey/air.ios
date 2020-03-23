//
//  AuthRequest.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 12/23/19.
//  Copyright © 2019 CityOS. All rights reserved.
//

import Foundation

struct AuthRequest: Codable {
  let refreshToken: String
  
  private enum CodingKeys: String, CodingKey {
    case refreshToken = "refresh_token"
  }
}

