//
//  Schema.swift
//  CityOSAir
//
//  Created by Andrej Saric on 04/02/2017.
//  Copyright © 2017 CityOS. All rights reserved.
//

import Foundation
import RealmSwift

class Schema: Object {
  @objc dynamic var deviceId: Int = 0
  @objc dynamic var schemaId: Int = 0
  let realmSchemaReadings = List<SchemaReading>()

  convenience init(deviceId: Int, schemaId: Int, schemaReadings: [SchemaReading]) {
    self.init()

    self.deviceId = deviceId
    self.schemaId = schemaId
    self.realmSchemaReadings.append(objectsIn: schemaReadings)
  }

  override static func primaryKey() -> String? {
    return "deviceId"
  }

  func getReadingForKey(key: Int) -> SchemaReading? {
    if let reading = realmSchemaReadings.filter({ $0.key == key }).first {
      return reading
    } else {
      return nil
    }
  }
}

class SchemaReading: Object {
  @objc dynamic var key: Int = 0
  @objc dynamic var whereType = ""
  @objc dynamic var readingTypeRaw = ""

  var readingType: ReadingType {
    get {
      if let type = ReadingType(rawValue: readingTypeRaw) {
        return type
      }

      return ReadingType.unidentified
    }
  }

  @objc dynamic var additional: String?

  convenience init(key: Int, whereType: String, readingType: String, additional: String?) {
    self.init()

    self.key = key
    self.whereType = whereType
    self.readingTypeRaw = readingType
    self.additional = additional
  }
}
