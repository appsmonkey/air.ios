//
//  ReadingParser.swift
//  CityOSAir
//
//  Created by Haris Kovacevic on 15/05/2019.
//  Copyright © 2019 CityOS. All rights reserved.
//

import Foundation

/// Schema parser
class ReadingParser {
  static let shared: ReadingParser = ReadingParser()
  
  private var schema: [String: AirSchema]?

  private init() {
    self.schema = ApplicationManager.shared.getSchema()
  }

  // parse schema and return `[AirReading]`
  func parse(data: [String: Double]) -> [AirReading] {
    if schema == nil {
      self.schema = ApplicationManager.shared.getSchema()
    }

    var readings: [AirReading] = []
    if let schema = self.schema {
      for result in data {
        if let schemaValue: AirSchema = schema[result.key] {
          let reading = AirReading(sensorId: result.key, value: result.value, type: (schemaValue.name)!)
          // support for newly added devices without strongly typed support in the code or dedicated assets
          if reading.readingType == .unidentified {
            reading.type = (schemaValue.name ?? " ") + "|" + (schemaValue.unit ?? " ")
          }
          // if schema reading has a name and it's not range add it
          if schemaValue.name != nil && !schemaValue.name!.lowercased().contains("range") {
            readings.append(reading)
          }
        }
      }
    }
    return readings
  }
}

