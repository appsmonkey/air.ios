//
//  ReadingCollection.swift
//  CityOSAir
//
//  Created by Andrej Saric on 06/11/2016.
//  Copyright © 2016 CityOS. All rights reserved.
//

import Foundation
import RealmSwift

class ReadingCollection: Object {

  @objc dynamic var id = 1
  @objc dynamic var lastUpdated: Date!
  @objc dynamic var isCityCollection = false
  let realmReadings = List<Reading>()

  convenience init(lastUpdated: Date, readings: [Reading], deviceId: Int, isCityCollection: Bool = false) {
    self.init()

    self.lastUpdated = lastUpdated
    self.realmReadings.append(objectsIn: readings)
    self.id = deviceId
    self.isCityCollection = isCityCollection
  }

  override static func primaryKey() -> String? {
    return "id"
  }

  func getReadingValue(type: ReadingType) -> Double {
    if let reading = realmReadings.filter({ $0.readingType == type }).first {
      return reading.value
    } else {
      return 0
    }
  }
}
