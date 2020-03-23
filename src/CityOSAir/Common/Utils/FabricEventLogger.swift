//
//  FabricEventLogger.swift
//  CityOSAir
//
//  Created by Andrej Saric on 13/03/2017.
//  Copyright © 2017 CityOS. All rights reserved.
//

import Foundation
import Crashlytics

enum Events: Int {
  case login = -1003
  case logout = -1004

  var name: String {
    switch self {
    case .login:
      return "User Logged In"
    case .logout:
      return "User Logged Out"
    }
  }
}

class FabricEventLogger {

  static func logNetworkRequest(requestUrl: String = "Well this is akward...", statusCode: Int, deviceId: Int? = nil, json: JSON? = nil) {

    var attributes = ["Request url": requestUrl,
                      "Status Code": statusCode] as [String: Any]

    if let json = json {
      attributes["Json Response"] = json
    } else {
      attributes["Json Response"] = "Response is null"
    }

    if let user = UserManager.sharedInstance.getLoggedInUser() {
      attributes["User Id"] = user.userId
    }

    if let deviceId = deviceId {
      attributes["Device Id"] = deviceId;
    }

    let error = NSError(domain: "(iOS) Network Request Failed", code: -1002, userInfo: attributes)

    logUser()
    Crashlytics.sharedInstance().recordError(error)
  }

  private static func logUser() {
    if let user = UserManager.sharedInstance.getLoggedInUser() {
      Crashlytics.sharedInstance().setUserEmail(user.email)
      Crashlytics.sharedInstance().setUserIdentifier("\(user.id)")
      Crashlytics.sharedInstance().setUserName(user.token)
    }
  }


  static func logCustomEvent(eventType: Events, attributes: [String: Any]) {
    let error = NSError(domain: eventType.name, code: eventType.rawValue, userInfo: attributes)
    Crashlytics.sharedInstance().recordError(error)

  }

}
