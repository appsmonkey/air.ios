//
//  Constants.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 12/19/19.
//  Copyright © 2019 CityOS. All rights reserved.
//

import Foundation

struct Constants {
  
  struct Measurement {
    static let readingTypeP10 = "PM10"
    static let readingTypeP25 = "PM2.5"
    static let defaultValue = "default"
    static let mapReadingsSensor = "AIR_PM10,AIR_PM2P5,AIR_AQI_RANGE"
    static let mapReadingsData = "AIR_PM10,AIR_PM2P5,AIR_TEMPERATURE,DEVICE_TEMPERATURE,AIR_AQI_RANGE"
  }
  
  struct Defaults {
    static let userEmail = "userEmail"
  }
  
  struct Cities {
    static let sarajevo = "Sarajevo"
  }
  
  struct Api {
    static let baseUrl = "https://apigway.cityos.io"
    static let deepLinkbaseUrl = "https://links.cityos.io"
  }
  
  struct Device {
    static let deviceUrl: String = "http://192.168.4.1/"
    static let deviceSaveUrl: String = "http://192.168.4.1/wifisave"
  }
  
  struct Events {
    static let deviceAdded: String = "deviceAdded"
  }
  
  struct Readings {
    static let sarajevo = "Sarajevo Air"
  }
  
  struct DeviceType {
    static let mine = "mine"
    static let outdoor = "outdoor"
    static let indoor = "indoor"
  }
  
  struct Location {
    struct Sarajevo {
      static let latitude = 43.852329
      static let longitude = 18.370026
    }
  }
  
  struct Keychain {
    static let serviceName = "io.cityos.cityosair"
  }
}
