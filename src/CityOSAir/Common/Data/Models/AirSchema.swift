//
//  AirSchema.swift
//  CityOSAir
//
//  Created by Haris Kovacevic on 25/04/2019.
//  Copyright © 2019 CityOS. All rights reserved.
//

import Foundation
import RealmSwift

class AirSchema: Object, Decodable {
  @objc dynamic var id: String = ""
  @objc dynamic var name: String?
  @objc dynamic var unit: String?
  @objc dynamic var defaultValue: String?
  @objc dynamic var parsePondition: String?
  var steps: List = List<Step>()

  private enum CodingKeys: String, CodingKey {
    case name
    case unit
    case steps
    case defaultValue = "default"
    case parsePondition = "parse_condition"
  }

  public required convenience init(from decoder: Decoder) throws {
    self.init()
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.name = try container.decode(String.self, forKey: .name)
    self.unit = try container.decode(String.self, forKey: .unit)
    let list = try container.decodeIfPresent([Step].self, forKey: .steps) ?? [Step()]
    steps.append(objectsIn: list)
    self.defaultValue = try container.decode(String.self, forKey: .defaultValue)
    self.parsePondition = try container.decode(String.self, forKey: .parsePondition)
  }
}

class Step: Object, Decodable {
  @objc dynamic var from: Double = 0;
  @objc dynamic var to: Double = 0;
  @objc dynamic var result: String?;

  private enum CodingKeys: String, CodingKey {
    case from
    case to
    case result
  }

  public required convenience init(from decoder: Decoder) throws {
    self.init()
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.from = try container.decode(Double.self, forKey: .from)
    self.to = try container.decode(Double.self, forKey: .to)
    self.result = try container.decode(String.self, forKey: .result)
  }
}


class RealmSchema: Object {
  @objc dynamic var id: Int = 0;
  var schema: List<AirSchema> = List();

  func initWith(schema: [String: AirSchema]) {
    self.schema.append(objectsIn: schema.map { e in
      e.value.id = e.key
      return e.value;
    });
  }

  func getSchema() -> [String: AirSchema]? {
    var dictionary: [String: AirSchema] = [:]
    self.schema.toArray().forEach { s in
      dictionary[String(s.id)] = s;
    };
    return dictionary;
  }

  override class func primaryKey() -> String? {
    return "id"
  }
}
