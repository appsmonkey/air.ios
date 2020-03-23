//
//  ChartEntry.swift
//  CityOSAir
//
//  Created by Haris Kovacevic on 25/04/2019.
//  Copyright © 2019 CityOS. All rights reserved.
//

import Foundation
import RealmSwift

class AirReading {
  var sensorId: String
  var value: Double
  var type: String
  var readingType: ReadingType {
    get {
      if let type = ReadingType(rawValue: self.type) {
        return type
      }

      return ReadingType.unidentified
    }
  }
  init(sensorId: String, value: Double, type: String) {
    self.sensorId = sensorId;
    self.value = value;
    self.type = type;
  }
}

struct AirReadings {
  var readings: [AirReading]
  var lastUpdated: Date

  init(readings: [AirReading], lastUpdated: Int) {
    self.readings = readings
    self.lastUpdated = Date(timeIntervalSince1970: TimeInterval(lastUpdated))
  }

  func getReadingValue(type: ReadingType) -> Double? {
    if let reading = readings.filter({ $0.readingType == type }).first {
      return reading.value
    } else {
      return nil
    }
  }
}

class ChartAirReadingContainer: Codable {
  let code: Int
  let errors: String?
  let requestId: String
  let data: [ChartAirReading]
}

class ChartAirReading: Codable {
  var date: Int = 0
  var value: Double = 0
}

struct MapAirReading: Codable {
  let sensorId: String
  let name: String
  var level: String
  var value: Double = 0.0
  var measurement: String
  var unit: String
}

struct MapMetaReading: Codable {
  let level: String
  let value: Double
  let measurement: String
  let unit: String
}

enum ReadingPeriod: Int {
  case live = 0
  case day
  case week
  case month

  func identifier() -> String {
    switch self {
    case .live:
      return "live"
    case .day:
      return "day"
    case .week:
      return "week"
    case .month:
      return "month"
    }
  }

  func duration() -> Int {
    switch self {
    case .live:
      return Int(Calendar.current.date(byAdding: .hour, value: -5, to: Date())!.timeIntervalSince1970)
    case .day:
      return Int(Calendar.current.date(byAdding: .day, value: -1, to: Date())!.timeIntervalSince1970)
    case .week:
      return Int(Calendar.current.date(byAdding: .day, value: -7, to: Date())!.timeIntervalSince1970)
    case .month:
      return Int(Calendar.current.date(byAdding: .day, value: -30, to: Date())!.timeIntervalSince1970)
    };
  }
}

enum ReadingGroup: String {
  case device = "device"
  case all = "all"
}

enum ReadingType: String {
  case temperature = "Temperature"
  case temperatureFeel = "Temperature Feel"
  case deviceTemperature = "Device Temperature"
  case humidity = "Air Humidity"
  case altitude = "Altitude"
  case uv = "uv"
  case light = "Light Intensity"
  case pm1 = "PM1"
  case pm25 = "PM2.5"
  case pm10 = "PM10"
  case noise = "noise"
  case co = "co"
  case co2 = "CO2"
  case no2 = "NO2"
  case pressure = "Air Pressure"
  case voc = "VOC"
  case soilMoisture = "Soil Moisture"
  case soilTemperature = "Soil Temperature"
  case waterLevel = "Water Level"
  case batteryPercentage = "Battery Percentage"
  case batteryVoltage = "Battery Voltage"
  case unidentified = ""

  var identifier: String {
    switch self {
    case .temperature:
      return "Temperature"
    case .temperatureFeel:
      return "Feels like"
    case .deviceTemperature:
      return "Device Temperature"
    case .humidity:
      return "Humidity"
    case .altitude:
      return "Altitude"
    case .uv:
      return "UV Light"
    case .light:
      return "Light"
    case .pm1:
      return "PM₁"
    case .pm25:
      return "PM2.5"//"PM₂.₅"
    case .pm10:
      return "PM10"//"PM₁₀"
    case .noise:
      return "Noise"
    case .co:
      return "CO"
    case .co2:
      return "CO2"
    case .no2:
      return "NO₂"
    case .pressure:
      return "Pressure"
    case .voc:
      return "Volatile organic compounds"
    case .soilMoisture:
      return "Soil Moisture"
    case .soilTemperature:
      return "Soil Temperature"
    case .waterLevel:
      return "Water Level"
    case .batteryPercentage:
      return "Battery Percentage"
    case .batteryVoltage:
      return "Battery Voltage"
    case .unidentified:
      return "Unidentified"
    }
  }

  var unitNotation: String {
    switch self {
    case .temperature, .temperatureFeel, .deviceTemperature:
      return "℃"
    case .humidity, .co, .no2, .co2, .batteryPercentage, .soilMoisture:
      return "%"
    case .altitude:
      return "m"
    case .uv:
      return "mW/cm³"
    case .light:
      return "lux"
    case .pm1, .pm25, .pm10:
      return "μg/m³"
    case .noise:
      return "db"
    case .pressure:
      return "hPa"
    case .voc:
      return "ppm"
    case .soilTemperature:
      return "℃"
    case .batteryVoltage:
      return "V"
    case .unidentified, .waterLevel:
      return ""
    }
  }

  var image: String {
    switch self {
    case .temperature, .temperatureFeel, .deviceTemperature:
      return "temperature"
    case .humidity:
      return "humidity"
    case .altitude:
      return "altitude"
    case .uv:
      return "lux"
    case .light:
      return "light"
    case .pm1, .pm10, .pm25:
      return "pm"
    case .noise:
      return "noise"
    case .co, .co2:
      return "co"
    case .no2:
      return "gas"
    case .pressure:
      return "pressure"
    case .voc:
      return "voc"
    case .soilMoisture:
      return "soilmoisture"
    case .soilTemperature:
      return "soiltemp"
    case .unidentified, .waterLevel, .batteryVoltage, .batteryPercentage:
      return "sensor-default"
    }
  }
}
