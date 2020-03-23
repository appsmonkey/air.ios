//
//  ApplicationManager.swift
//  CityOSAir
//
//  Created by Haris Kovacevic on 14/05/2019.
//  Copyright © 2019 CityOS. All rights reserved.
//

import Foundation
import RealmSwift

/// Application manager handles only schema. Refactor out in migration to Core Data
class ApplicationManager {
  public static let shared = ApplicationManager()
  let realm = try! Realm()

  func saveSchema(schema: [String: AirSchema]?) -> Void {
    guard let schema = schema else {
      return
    }

    try! self.realm.write {
      let realmSchema = RealmSchema();
      realmSchema.initWith(schema: schema);
      self.realm.add(realmSchema, update: .all)
    }
  }

  func getSchema() -> [String: AirSchema]? {
    let schema = realm.objects(RealmSchema.self).first?.getSchema()
    return schema
  }
}
