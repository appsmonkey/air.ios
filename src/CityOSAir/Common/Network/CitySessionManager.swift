//
//  CitySessionManager.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 12/23/19.
//  Copyright © 2019 CityOS. All rights reserved.
//

import KeychainAccess

final class CitySessionManager {
  static let shared = CitySessionManager()
  private init() { }

  // MARK: - Private properties -

  private let idTokenKeychainKey = "idTokenKeychainKey"
  private let accessTokenKeychainKey = "accessTokenKeychainKey"
  private let refreshTokenKeychainKey = "refreshTokenKeychainKey"

  private let keychain = Keychain(service: Constants.Keychain.serviceName).accessibility(.whenUnlocked)

  // MARK: - Public properties -

  var idToken: String? {
    get {
      return keychain[idTokenKeychainKey]
    }
    set {
      keychain[idTokenKeychainKey] = newValue
    }
  }

  var accessToken: String? {
    get {
      return keychain[accessTokenKeychainKey]
    }
    set {
      keychain[accessTokenKeychainKey] = newValue
    }
  }

  var refreshToken: String? {
    get {
      return keychain[refreshTokenKeychainKey]
    }
    set {
      keychain[refreshTokenKeychainKey] = newValue
    }
  }

  var userEmail: String {
    get {
      guard let email = UserDefaults.standard.string(forKey: Constants.Defaults.userEmail) else {
        return ""
      }
      return email
    }
    set {
      UserDefaults.standard.set(newValue, forKey: Constants.Defaults.userEmail)
    }
  }
}
