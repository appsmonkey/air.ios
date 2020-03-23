//
//  SchemeParser.swift
//  CityOSAir
//
//  Created by Andrej Saric on 04/02/2017.
//  Copyright © 2017 CityOS. All rights reserved.
//

import Foundation

/*
 "sense": {
 "1": "air temperature",
 "2": "air humidity",
 "3": "air temperature_feel",
 "4": "air pm 1",
 "5": "air pm 2.5",
 "6": "air pm 10",
 "7": "air aqi range",
 "8": "air pm 2.5 range",
 "9": "air pm 10 range"
 }
 */


class SchemeParser {

  private var readings: [SchemaReading] = []
  
  init(json: JSON) {
    guard let sense = json.dictionaryObject else {
      return
    }

    for (key, value) in sense {
      guard let key = Int(key), let value = value as? String else {
        continue
      }
      let schemaValues = (value).components(separatedBy: " ")
      if schemaValues.count == 1 {
        continue
      }

      let whereType = schemaValues[0]
      var whatType = schemaValues[1]
      var additional = schemaValues[safe: 2]

      if whatType == "pm" {
        whatType += schemaValues[2]
        additional = schemaValues[safe: 3]
      }

      let reading = SchemaReading(key: key, whereType: whereType, readingType: whatType, additional: additional)
      readings.append(reading)    }

  }

  func getReadingsSchema() -> [SchemaReading] {
    return self.readings
  }

}
