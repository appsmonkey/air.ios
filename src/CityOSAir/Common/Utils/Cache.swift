//
//  Cache.swift
//  CityOSAir
//
//  Created by Andrej Saric on 06/11/2016.
//  Copyright © 2016 CityOS. All rights reserved.
//

import Foundation
import RealmSwift

protocol CacheUsable: class {
  func didUpdateDeviceCache()
}

// TODO: Migrate to core data
final class Cache {
  static let sharedCache = Cache()
  private init() { }

  weak var delegate: CacheUsable?

  func saveCity(city: City) {
    do {
      let realm = try Realm()
      try realm.write {
        realm.add(city, update: .all)
      }
      return
    } catch {
      print(error)
    }
  }

  func getCity() -> City? {
    do {
      let realm = try Realm()
      if let realmCity = realm.objects(City.self).first {
        let city = City()
        city.name = realmCity.name
        city.deviceName = realmCity.deviceName
        city.id = realmCity.id
        return city
      }
      return nil
    } catch {
      print(error)
      return nil
    }
  }

  func saveReadingCollection(readingCollection: ReadingCollection) {
    do {
      let realm = try Realm()
      try realm.write {
        realm.add(readingCollection, update: .all)
      }
      return
    } catch {
      print(error)
    }
  }

  func getReadingCollectionForDevice(deviceId: Int) -> ReadingCollection? {
    do {
      let realm = try Realm()
      if let result = realm.object(ofType: ReadingCollection.self, forPrimaryKey: deviceId) {
        return result
      }
      return nil
    } catch {
      print(error)
      return nil
    }
  }

  func updatePredefinedDevices(deviceCollection: [Device]) {
    do {
      let realm = try Realm()
      let realmDevices = realm.objects(Device.self).filter("isCityDevice == true")
      try realm.write {
        realm.delete(realmDevices)
        realm.add(deviceCollection, update: .all)
      }
      return
    } catch {
      print(error)
    }
  }


  func saveDevices(deviceCollection: [Device]) {
    do {
      let realm = try Realm()
      let realmDevices = realm.objects(Device.self).filter("isCityDevice != true")
      try realm.write {
        realm.delete(realmDevices)
        realm.add(deviceCollection, update: .all)
        delegate?.didUpdateDeviceCache()
      }
      return
    } catch {
      print(error)
    }
  }

  func getDeviceCollection() -> [Device]? {
    do {
      let realm = try Realm()
      return realm.objects(Device.self).toArray()
    } catch {
      print(error)
      return nil
    }
  }

  func getDeviceForName(name: String) -> Device? {
    do {
      let realm = try Realm()
      if let realmDevice = realm.objects(Device.self).filter("name = %@", name).first {
        let device = Device()
        device.active = realmDevice.active
        device.addOn = realmDevice.addOn
        device.editOn = realmDevice.editOn
        device.id = realmDevice.id
        device.identification = realmDevice.identification
        device.indoor = realmDevice.indoor
        device.location = realmDevice.location
        device.name = realmDevice.name
        device.schemaId = realmDevice.schemaId
        device.isCityDevice = realmDevice.isCityDevice
        return device
      }
      return nil
    } catch {
      print(error)
      return nil
    }
  }

  func saveSchema(schema: Schema) {
    do {
      let realm = try Realm()
      try realm.write {
        realm.add(schema, update: .all)
      }
      return
    } catch {
      print(error)
    }
  }

  func getSchemaFor(deviceId: Int) -> Schema? {
    do {
      let realm = try Realm()
      if let result = realm.object(ofType: Schema.self, forPrimaryKey: deviceId) {
        return result
      } else {
        return nil
      }
    } catch {
      print(error)
      return nil
    }
  }

}
