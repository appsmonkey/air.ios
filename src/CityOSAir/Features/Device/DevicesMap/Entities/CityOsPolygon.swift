//
//  CityOsPolygon.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 12/29/19.
//  Copyright © 2019 CityOS. All rights reserved.
//

import Foundation
import MapKit

class CityOSPolygon: MKPolygon {
  var pm25: Double? = nil
  var pm10: Double? = nil
  var aqi: AQI = .zero
  var zone: Zone? {
    didSet {
      pm25 = getReading(readingType: "PM2.5")?.value
      pm10 = getReading(readingType: "PM10")?.value
    }
  }
  var fillColor: UIColor?
  var strokeColor: UIColor?
  var strokeWidth: CGFloat?
  var isTappable: Bool?
  
  override init() {
    super.init()
  }
    
  func updateAqi() {
    let pm25AQI = AQI.getAQIForTypeWithValue(value: pm25, aqiType: .pm25)
    let pm10AQI = AQI.getAQIForTypeWithValue(value: pm10, aqiType: .pm10)
    
    aqi = pm25AQI.rawValue > pm10AQI.rawValue ? pm25AQI: pm10AQI
  }
  
  private func getReading(readingType: String) -> MapAirReading? {
    let reading = zone?.data.first(where: { readingType.elementsEqual($0.measurement) })
    return reading
  }
  
}
