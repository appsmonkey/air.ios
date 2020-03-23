//
//  CityOSMapDevice.swift
//  CityOSAir
//
//  Created by Andrej Saric on 17/04/2017.
//  Copyright © 2017 CityOS. All rights reserved.
//

import Foundation

class CityOSMapDevice {

  var name: String
  var location: MapLocation
  var pm25Value: Double?
  var pm10Value: Double?
  var tempValue: Double?

  init(json: JSON) {

    name = json["name"].string ?? "Default Name"


    location = MapLocation(forDeviceWithJson: json["location"])

    pm25Value = json["values"]["5"].double
    pm10Value = json["values"]["6"].double
    tempValue = json["values"]["1"].double
  }

  func aqi() -> AQI {
    let pm2_5AQI = AQI.getAQIForTypeWithValue(value: pm25Value, aqiType: .pm25)
    let pm10AQI = AQI.getAQIForTypeWithValue(value: pm10Value, aqiType: .pm10)

    return pm2_5AQI.rawValue > pm10AQI.rawValue ? pm2_5AQI: pm10AQI

  }

  func has25() -> Bool {
    return pm25Value != nil
  }

  func has10() -> Bool {
    return pm10Value != nil
  }
}
