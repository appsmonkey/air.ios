//
//  Device.swift
//  CityOSAir
//
//  Created by Haris Kovacevic on 25/04/2019.
//  Copyright © 2019 CityOS. All rights reserved.
//

import Foundation
import RealmSwift

struct AirDevice: Codable {
  var deviceId: String
  var name: String
  var active: Bool
  var model: String
  var indoor: Bool
  var mine: Bool
  var defaultDevice: Bool? = false
  var location: LatLng?
  var latest: [String: Double]?
  var mapMeta: [String: MapMetaReading]? = [:]
  var timestamp: Int?
  var deviceToken: String? {
    get {
      if let isDefault = defaultDevice {
        if isDefault {
          return nil
        }
      }
      return deviceId;
    }
  }
}

extension AirDevice: Persistable {
  public init(managedObject: AirDeviceObject) {
    deviceId = managedObject.deviceId
    name = managedObject.name
    active = managedObject.active
    indoor = managedObject.indoor
    model = managedObject.model
    mine = managedObject.mine
    defaultDevice = managedObject.defaultDevice
    location = LatLng()
    latest = [:]
    mapMeta = [:]
  }
  public func managedObject() -> AirDeviceObject {
    let device = AirDeviceObject()
    device.deviceId = deviceId
    device.name = name
    device.active = active
    device.indoor = indoor
    device.model = model
    device.mine = mine
    return device
  }
}

class AirDeviceObject: Object {
  @objc dynamic var deviceId: String = " ";
  @objc dynamic var name: String = " ";
  @objc dynamic var active: Bool = false;
  @objc dynamic var model: String = " ";
  @objc dynamic var indoor: Bool = false;
  @objc dynamic var mine: Bool = false;
  @objc dynamic var defaultDevice: Bool = false;

  override class func primaryKey() -> String? {
    return "deviceId"
  }
}

struct AirDevicePayload: Codable {
  var token: String
  var name: String
  var coordinates: LatLng
  var model: String = "Boxy"
  var indoor: Bool = false
  var city: String
}

extension AirDevice {
  static public var defaultDevices: [AirDevice] {
    var devices: [AirDevice] = []
    devices.append(AirDevice(deviceId: "",
      name: "Sarajevo Air",
      active: true, model: "N/A",
      indoor: false, mine: false,
      defaultDevice: true,
      location: nil,
      latest: nil,
      mapMeta: nil,
      timestamp: nil))
    return devices
  }
}
