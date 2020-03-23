//
//  Enviroment.swift
//  CityOSAir
//
//  Created by Haris Kovacevic on 29/05/2019.
//  Copyright © 2019 CityOS. All rights reserved.
//

import Foundation

public enum Environment {
  private static let infoDictionary: [String: Any] = {
    var dict: NSDictionary?
    if let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist") {
      dict = NSDictionary(contentsOfFile: path)
    }
    return dict!.swiftDictionary
  }()

  static let googleApiKey: String = {
    guard let apiKey = Environment.infoDictionary["API_KEY"] as? String else {
      fatalError("API Key not set in plist for this environment")
    }
    return apiKey
  }()

  static let googleSignInClientId: String = {
    guard let apiKey = Environment.infoDictionary["CLIENT_ID"] as? String else {
      fatalError("API Key not set in plist for this environment")
    }
    return apiKey
  }()
}
