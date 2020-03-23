//
//  AccountStatusResponse.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 12/26/19.
//  Copyright © 2019 CityOS. All rights reserved.
//

import Foundation

struct AccountStatusResponse: Codable {
  let requestId: String
  let code: Int
  let errors: String?
  let data: Data
  
  struct Data: Codable {
    let exists: Bool
    let confirmed: Bool
  }
}
