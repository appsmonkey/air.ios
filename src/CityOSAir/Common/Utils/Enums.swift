//
//  Enums.swift
//  CityOSAir
//
//  Created by Andrej Saric on 28/08/16.
//  Copyright © 2016 CityOS. All rights reserved.
//

import Foundation

enum CellType {
  case email
  case password
  case confirmPassword
  case wiFiName
  case wiFiPassword
  case bigBtn
  case bigBtnSecondary
  case smallBtn
  case socialLogin
}


enum MenuCells {

  case cityAir
  case cityMap
  case cityDevice(name: String)
  case logIn
  case aqiPM10
  case aqiPM25
  case settings
  case deviceRefresh
  case addDevice

  var text: String {
    switch self {
    case .cityAir:
      return UserManager.sharedInstance.currentCity.deviceName
    case .cityMap:
      return Text.Menu.cityMap
    case .cityDevice(let name):
      return name
    case .logIn:
      return Text.Menu.logIn
    case .aqiPM10:
      return Text.Menu.aqiPM10
    case .aqiPM25:
      return Text.Menu.aqiPM25
    case .settings:
      return Text.Menu.settings
    case .deviceRefresh:
      return Text.Menu.deviceRefresh
    case .addDevice:
      return "Add Device"
    }
  }
}

public enum Timeframe: String {
  case live = ""
  case day = "day"//hour
  case week = "week"//day
  case month = "month"
}
