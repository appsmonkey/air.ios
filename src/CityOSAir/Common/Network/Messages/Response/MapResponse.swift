//
//  MapResponse.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 12/18/19.
//  Copyright © 2019 CityOS. All rights reserved.
//

import Foundation

struct MapResponse: Codable {
  let code: Int
  let errors: String?
  let requestId: String
  let data: Data
  
  struct Data: Codable {
    let zones: [Zone]
    let devices: [Device]
    
    struct Zone: Codable {
      let zoneId: String
      let data: [Data]
      
      struct Data: Codable {
        let sensorId: String
        let name: String
        let level: String
        let value: String
        let measurement: String
        let unit: String
      }
    }
    
    struct Device: Codable {
      let deviceId: String
      let name: String
      let active: Bool
      let model: String
      let indoor: Bool
      let defaultDevice: Bool
      let mine: Bool
      let location: Location
      let mapMeta: [String: MapReading] = [:]
      let latest: [String: Double]?
      let timestamp: Int
      let zoneId: String
      
      struct MapReading: Codable {
        let level: String
        let value: Double
        let measurement: String
        let unit: String
      }
    
      struct Location: Codable {
        let lat: Double
        let lng: Double
      }
    }
  }
}
