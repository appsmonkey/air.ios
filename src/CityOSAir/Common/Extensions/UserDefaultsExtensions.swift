//
//  UserDefaultsExtensions.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 11/28/19.
//  Copyright © 2019 CityOS. All rights reserved.
//

import Foundation

extension UserDefaults {
  func isAppAlreadyLaunchedOnce() -> Bool {
    if let isAppAlreadyLaunchedOnce = UserDefaults.standard.string(forKey: "isAppAlreadyLaunchedOnce") {
      print("App already launched : \(isAppAlreadyLaunchedOnce)")
      return true
    } else {
      UserDefaults.standard.set(true, forKey: "isAppAlreadyLaunchedOnce")
      print("App launched first time")
      return false
    }
  }

  func setAppAlreadyLaunched(_ launched: Bool) {
    UserDefaults.standard.set(launched, forKey: "isAppAlreadyLaunchedOnce")
  }
}
