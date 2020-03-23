//
//  DevicesStore.swift
//  CityOSAir
//
//  Created by Haris Kovacevic on 26/04/2019.
//  Copyright © 2019 CityOS. All rights reserved.
//

import Foundation
import RealmSwift

class DeviceStore {
  public static let shared = DeviceStore();
  let realm = try! Realm();

  private init() { }

  func save(devices: [AirDevice]) -> Void {
    removeDevices();
    try! realm.write {
      realm.add(devices.map { $0.managedObject() }, update: .all)
    }
  }

  func save(device: AirDevice) -> Void {
    try! realm.write {
      realm.add(device.managedObject(), update: .all)
    }
  }

  func removeDevices() -> Void {
    try! realm.write {
      realm.delete(realm.objects(AirDeviceObject.self).filter { !$0.defaultDevice })
    }
  }

  func getDevices() -> [AirDevice]? {
    return realm.objects(AirDeviceObject.self).toArray().map { AirDevice(managedObject: $0) }
  }
  
  func getMyDevices() -> [AirDevice]? {
    let myDevices = realm.objects(AirDeviceObject.self).filter("mine == true").toArray().map { AirDevice(managedObject: $0) }
    return myDevices
  }
  
  /// get my device based on the specification where if there are outdoor devices give me first alphabetically, if no give me first indoor device alphabetically, if not return nil
  func getMyDevice() -> AirDevice? {
    let indoorDevices = realm.objects(AirDeviceObject.self).filter("mine == true && indoor == true").toArray().map { AirDevice(managedObject: $0) }
    let outdoorDevices = realm.objects(AirDeviceObject.self).filter("mine == true && indoor != true").toArray().map { AirDevice(managedObject: $0) }
    
    var indoorDevicesSorted = [AirDevice]()
    for device in indoorDevices where device.name != Constants.Readings.sarajevo {
      indoorDevicesSorted.append(device)
    }
    
    indoorDevicesSorted = indoorDevicesSorted.sorted { $0.name.lowercased() < $1.name.lowercased() }
    
    var outdorDevicesSorted = [AirDevice]()
    for device in outdoorDevices where device.name != Constants.Readings.sarajevo {
      outdorDevicesSorted.append(device)
    }
    
    indoorDevicesSorted = indoorDevicesSorted.sorted { $0.name.lowercased() < $1.name.lowercased() }
    outdorDevicesSorted = outdorDevicesSorted.sorted { $0.name.lowercased() < $1.name.lowercased() }
    
    if outdorDevicesSorted.count > 0 {
      return outdorDevicesSorted[0]
    } else if indoorDevicesSorted.count > 0 {
      return indoorDevicesSorted[0]
    }
    return nil
  }

  func getDevice(name: String) -> AirDevice? {
    return realm.objects(AirDeviceObject.self).filter("name == %@", name).first.map { AirDevice(managedObject: $0) }
  }
  
  func getDevice(deviceId: String) -> AirDevice? {
    return realm.objects(AirDeviceObject.self).filter("deviceId == %@", deviceId).first.map { AirDevice(managedObject: $0) }
  }

  func getDefaultDevice() -> AirDevice? {
    return realm.objects(AirDeviceObject.self).first.map { AirDevice(managedObject: $0) }
  }

}


