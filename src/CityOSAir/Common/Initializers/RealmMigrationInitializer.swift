//
//  RealmMigrationInitializer.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 1/8/20.
//  Copyright © 2020 CityOS. All rights reserved.
//

import RealmSwift
import Realm

class RealmMigrationInitializer: Initializable {
  
  var shouldMigrate = false
  
  func initialize() {
    Realm.Configuration.defaultConfiguration.deleteRealmIfMigrationNeeded = true
    
    let config = Realm.Configuration(
      // Set the new schema version. This must be greater than the previously used
      // version (if you've never set a schema version before, the version is 0).
      schemaVersion: 24,
      
      // Set the block which will be called automatically when opening a Realm with
      // a schema version lower than the one set above
      migrationBlock: { migration, oldSchemaVersion in
        // We haven’t migrated anything yet, so oldSchemaVersion == 0
        if (oldSchemaVersion < 24) {
          self.shouldMigrate = true
        }
    })
    
    // Tell Realm to use this new configuration object for the default Realm
    Realm.Configuration.defaultConfiguration = config
    
    // Now that we've told Realm how to handle the schema change, opening the file
    // will automatically perform the migration
    let _ = try! Realm()
    
    migrate()
  }
  
  func migrate() {
    if shouldMigrate {
      Cache.sharedCache.saveCity(city: AirCity.sarajevo.city)
      let predefinedDevices = DefinedDevices().getPredefinedDevices()
      Cache.sharedCache.updatePredefinedDevices(deviceCollection: predefinedDevices)
    }
  }
  
}
