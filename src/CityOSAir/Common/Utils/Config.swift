//
//  Config.swift
//  CityOSAir
//
//  Created by Andrej Saric on 21/02/2017.
//  Copyright © 2017 CityOS. All rights reserved.
//
import Foundation

enum AppConfiguration {
  case debug
  case testFlight
  case appStore
}

struct Config {

  private static let isTestFlight = Bundle.main.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt"

  static var isDebug: Bool {
    #if DEBUG
      return true
    #else
      return false
    #endif
  }

  static var appConfiguration: AppConfiguration {
    if isDebug {
      return .debug
    } else if isTestFlight {
      return .testFlight
    } else {
      return .appStore
    }
  }
}
