//
//  Sensor.swift
//  CityOSAir
//
//  Created by Haris Kovacevic on 25/04/2019.
//  Copyright © 2019 CityOS. All rights reserved.
//

import Foundation
import RealmSwift

class Sensor: Object, Decodable {
  @objc dynamic var sensorId: String?
  @objc dynamic var name: String?;
  @objc dynamic var level: String?;
  @objc dynamic var value: Double = 0.0;
  @objc dynamic var measurement: String?;
  @objc dynamic var unit: String?;

  override class func primaryKey() -> String? {
    return "sensorId"
  }

  private enum CodingKeys: String, CodingKey {
    case sensorId = "sensor_id"
    case name
    case level
    case value
    case measurement
    case unit
  }

  public required convenience init(from decoder: Decoder) throws {
    self.init()
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.sensorId = try container.decodeIfPresent(String.self, forKey: .sensorId)
    self.name = try container.decodeIfPresent(String.self, forKey: .name)
    self.level = try container.decode(String.self, forKey: .level)
    self.value = try container.decode(Double.self, forKey: .value)
    self.measurement = try container.decode(String.self, forKey: .measurement)
    self.unit = try container.decode(String.self, forKey: .unit)
  }

}
