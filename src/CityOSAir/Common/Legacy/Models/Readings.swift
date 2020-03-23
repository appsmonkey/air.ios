//
//  Readings.swift
//  CityOSAir
//
//  Created by Andrej Saric on 01/09/16.
//  Copyright © 2016 CityOS. All rights reserved.
//

import Foundation
import RealmSwift

class Reading: Object {

  @objc dynamic var readingTypeRaw = ""
  @objc dynamic var value = 0.0
  @objc dynamic var sensorId = 0

  var readingType: ReadingType {
    get {
      if let type = ReadingType(rawValue: readingTypeRaw) {
        return type
      }

      return ReadingType.unidentified
    }
  }

  convenience init(type: String, sensorId: Int, value: Double) {
    self.init()
    
    self.readingTypeRaw = type
    self.sensorId = sensorId
    self.value = value
  }
}
