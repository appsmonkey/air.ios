//
//  AirCity.swift
//  CityOSAir
//
//  Created by Andrej Saric on 22/05/2017.
//  Copyright © 2017 CityOS. All rights reserved.
//

import RealmSwift

class City: Object {
  @objc dynamic var id = 1
  @objc dynamic var cityId: Int = 0
  @objc dynamic var name: String = ""
  @objc dynamic var deviceName: String = ""

  convenience init(id: Int, name: String, deviceName: String) {
    self.init()

    self.cityId = id
    self.name = name
    self.deviceName = deviceName
  }

  override static func primaryKey() -> String? {
    return "id"
  }
}
