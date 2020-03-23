//
//  AddDeviceResponse.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 1/8/20.
//  Copyright © 2020 CityOS. All rights reserved.
//

import Foundation

struct AddDeviceResponse: Codable {
  let requestId: String
  let code: Int
  let errors: String?
  let data: Data
  
  struct Data: Codable {
    let token: String
  }
}
