//
//  Map.swift
//  CityOSAir
//
//  Created by Haris Kovacevic on 25/04/2019.
//  Copyright © 2019 CityOS. All rights reserved.
//

import Foundation

struct Map: Codable {
  let code: Int
  let errors: String?
  let data: AirMap
}

struct AirMap: Codable {
  var zones: [Zone]
  var devices: [AirDevice]
}

struct Zone: Codable {
  var zoneId: String
  var zoneName: String
  var data: [MapAirReading]
}


