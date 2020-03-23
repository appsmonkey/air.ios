//
//  GetDeviceResponse.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 12/16/19.
//  Copyright © 2019 CityOS. All rights reserved.
//

import Foundation

struct DeviceResponse: Codable {
  let requestId: String
  let code: Int
  let errors: String?
  let data: Data
  
  struct Data: Codable {
    let deviceId: String
    let name: String
    let active: Bool
    let model: String
    let indoor: Bool
    let defaultDevice: Bool
    let mine: Bool
    let location: Location
    let mapMeta: [String: MapMeta]?
    let latest: [String: Double]?
    let timestamp: Int
    let zoneId: String
    
    struct Location: Codable {
      let lat: Double
      let lng: Double
    }
    
    struct MapMeta: Codable {
      let level: String
      let value: Double
      let measurement: String
      let unit: String
    }
  }
}
