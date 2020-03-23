//
//  MapDeviceMarker.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 12/17/19.
//  Copyright © 2019 CityOS. All rights reserved.
//

import Foundation

class MapDeviceMarker {
  let device: AirDevice
  var pm25: Double? = nil
  var pm10: Double? = nil
  var level: String? = nil
  var aqi: AQI = .zero

  init(device: AirDevice) {
    self.device = device
    if device.active {
      pm25 = getReading(readingType: Constants.Measurement.readingTypeP25)?.value
      pm10 = getReading(readingType: Constants.Measurement.readingTypeP10)?.value
      level = getReading(readingType: Constants.Measurement.defaultValue)?.level
    }
    configureAQI()
  }

  func configureAQI() {
    let pm2_5AQI = AQI.getAQIForTypeWithValue(value: pm25, aqiType: .pm25)
    let pm10AQI = AQI.getAQIForTypeWithValue(value: pm10, aqiType: .pm10)

    aqi = pm2_5AQI.rawValue > pm10AQI.rawValue ? pm2_5AQI: pm10AQI
  }

  private func getReading(readingType: String) -> MapMetaReading? {
    let reading = device.mapMeta?.first(where: { readingType.elementsEqual($0.value.measurement) })?.value
    return reading
  }
}
