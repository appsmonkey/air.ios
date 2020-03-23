//
//  UserManager.swift
//  CityOSAir
//
//  Created by Andrej Saric on 01/09/16.
//  Copyright © 2016 CityOS. All rights reserved.
//

import Foundation
import RealmSwift

enum AirCity: String {
  case sarajevo = "Sarajevo"
  case belgrade = "Belgrade"

  var id: Int {
    switch self {
    case .sarajevo:
      return 1
    case .belgrade:
      return 3
    }
  }

  var latLng: (latitude: Double, longitude: Double) {
    switch self {
    case .sarajevo:
      return (43.84195592377653, 18.36536407470703)
    case .belgrade:
      return (44.786568, 20.448922)
    }
  }

  var deviceName: String {
    switch self {
    case .sarajevo:
      return "Sarajevo Air"
    case .belgrade:
      return "Belgrade Air"
    }
  }

  var city: City {
    return City(id: self.id, name: self.rawValue, deviceName: self.deviceName)
  }
}

protocol UserManagable: class {
  func didSwitchToCity(city: AirCity)
}

class UserManager {

  var delegate: UserManagable?

  let realm = try! Realm()

  static let sharedInstance = UserManager()

  var currentCity: AirCity = .sarajevo {
    didSet {
      Cache.sharedCache.saveCity(city: currentCity.city)
      delegate?.didSwitchToCity(city: currentCity)
      guard let devices = Cache.sharedCache.getDeviceCollection() else {
        return
      }

      for device in devices.filter ({ $0.isCityDevice }) {
        try! self.realm.write {
          if device.name == self.currentCity.deviceName {
            device.active = true
          } else {
            device.active = false
          }
        }
      }
    }
  }

  init() { }

  func getLoggedInUser() -> User? {
    return realm.objects(User.self).first
  }

  func logoutUser() {

    let users = self.realm.objects(User.self)

    try! self.realm.write {
      self.realm.delete(users)
    }

    clearDevices()
    clearReadings()

  }

  func clearDevices() {
    let devices = self.realm.objects(Device.self).filter("isCityDevice != %d", 1)

    try! self.realm.write {
      self.realm.delete(devices)
    }
  }

  func clearReadings() {

    let readings = self.realm.objects(ReadingCollection.self).filter("isCityCollection != %d", 1)

    try! self.realm.write {
      self.realm.delete(readings)
    }
  }

//    @discardableResult func associateDeviceWithUser(_ deviceID: Int) -> User? {
//
//        let user = self.realm.objects(User.self).first
//
//        try! self.realm.write {
//            user!.deviceId.value = deviceID
//        }
//
//        return user
//    }
//
//    @discardableResult func deAssociateDeviceWithUser() -> User? {
//
//        let user = self.realm.objects(User.self).first
//
//        try! self.realm.write {
//            user!.deviceId.value = nil
//        }
//
//        return user
//    }

//  func logingWithCredentials(_ email: String, password: String, completion: @escaping (_ result: User?, _ hasDevice: Bool, _ message: String) -> Void) {
//    AirService.login(["email": email, "password": password]) { (success, message, user) in
//
//      if success {
//
//        if let usr = user {
//
//          usr.email = email
//          usr.password = password
//
//          try! self.realm.write {
//            self.realm.add(usr, update: .all)
//          }
//
//          AirService.device({ (success, message, devices) in
//            if success {
//
//              if let devices = devices {
//
//                for device in devices {
//                  AirService.schemaFor(deviceID: device.id, completion: { success, msg, schema in
//                    if success, let schema = schema {
//                      Cache.sharedCache.saveSchema(schema: schema)
//                    }
//                  })
//                }
//
//                Cache.sharedCache.saveDevices(deviceCollection: devices)
//                completion(user, true, message)
//                return
//              }
//            }
//
//            completion(user, false, message)
//          })
//        } else {
//          self.logoutUser()
//          completion(nil, false, message)
//        }
//      } else {
//        self.logoutUser()
//        completion(nil, false, message)
//      }
//    }
//  }
//
//  func registerUser(_ email: String, password: String, confirmPassword: String, completion: @escaping (_ message: String?, _ success: Bool) -> Void) {
//    AirService.register(["email": email, "password": password, "passwordConfirm": confirmPassword]) { (success, message) in
//      if success {
//        self.logingWithCredentials(email, password: password) { (result, hasDevice, message) in
//          if result != nil {
//            completion("Logged in", true)
//          } else {
//            completion("Log in failed", false)
//          }
//        }
//      } else {
//        completion("Account creation failed", false)
//      }
//    }
//  }
//
//  func resetPassword(_ email: String, completion: (_ success: Bool) -> Void) {
//    completion(true)
//  }
//}
}
