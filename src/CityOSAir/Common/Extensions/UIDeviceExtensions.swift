//
//  UIDeviceExtensions.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 11/28/19.
//  Copyright © 2019 CityOS. All rights reserved.
//

import UIKit
import SystemConfiguration.CaptiveNetwork

extension UIDevice {

  static var SSID: String? {
    get {
      if let interfaces = CNCopySupportedInterfaces() as NSArray? {
        for interface in interfaces {
          if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as! CFString) as NSDictionary? {
            return interfaceInfo[kCNNetworkInfoKeySSID as String] as? String
          }
        }
      }
      return nil
    }
  }

  static var BSSID: String? {
    get {
      if let interfaces = CNCopySupportedInterfaces() as NSArray? {
        for interface in interfaces {
          if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as! CFString) as NSDictionary? {
            return interfaceInfo[kCNNetworkInfoKeyBSSID as String] as? String
          }
        }
      }
      return nil
    }
  }

  static var delta: CGFloat {
    if UIDevice.isDeviceWithHeight480() {
      return 1.3 //1
    } else if UIDevice.isDeviceWithHeight568() {
      return 1.5
    } else if UIDevice.isDeviceWithHeight667() {
      return 1.8//2
    } else {
      return 2
    }
  }

  class func isDeviceWithWidth320 () -> Bool {
    if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone {
      if UIScreen.main.bounds.size.width == CGFloat(320.0) {
        return true;
      }
    }
    return false;
  }

  class func isDeviceWithWidth375 () -> Bool {
    if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone {
      if UIScreen.main.bounds.size.width == CGFloat(375.0) {
        return true;
      }
    }
    return false;
  }

  class func isDeviceWithWidth414 () -> Bool {
    if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone {
      if UIScreen.main.bounds.size.width == CGFloat(414.0) {
        return true;
      }
    }
    return false;
  }

  class func isDeviceWithHeight480 () -> Bool {
    if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone {
      if UIScreen.main.bounds.size.height == CGFloat(480.0) {
        return true;
      }
    }
    return false;
  }

  class func isDeviceWithHeight568 () -> Bool {
    if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone {
      if UIScreen.main.bounds.size.height == CGFloat(568.0) {
        return true;
      }
    }
    return false;
  }

  class func isDeviceWithHeight667 () -> Bool {
    if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone {
      if UIScreen.main.bounds.size.height == CGFloat(667.0) {
        return true;
      }
    }
    return false;
  }

  class func isDeviceWithHeight736 () -> Bool {
    if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone {
      if UIScreen.main.bounds.size.height == CGFloat(736.0) {
        return true;
      }
    }
    return false;
  }
}
