//
//  AddDeviceRequest.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 12/3/19.
//  Copyright © 2019 CityOS. All rights reserved.
//

import Foundation

struct AddDeviceRequest: Codable {
  let token: String
  let name: String
  let city: String
  let model: String
  let indoor: Bool
  let coordinates: Coordinates
  
  struct Coordinates: Codable {
    let lng: Double
    let lat: Double
  }
}
