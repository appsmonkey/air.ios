//
//  AirUserManager.swift
//  CityOSAir
//
//  Created by Haris Kovacevic on 26/04/2019.
//  Copyright © 2019 CityOS. All rights reserved.
//

import Foundation
import RealmSwift
import AirshipKit

/// User manager class to handle profile reading and updaring and provide session utility methods
class AirUserManager {
  public static let shared = AirUserManager();
  let realm = try! Realm();

  func updateProfile(profile: UserProfile) {
    try! self.realm.write {
      self.realm.add(profile.managedObject(), update: .all);
    }
  }

  func getProfile() -> UserProfile? {
    return self.realm.objects(UserProfileObject.self).first.map { UserProfile(managedObject: $0) }
  }

  private func removeProfile() {
    if let profile = self.realm.objects(UserProfileObject.self).first {
      try! self.realm.write {
        self.realm.delete(profile);
      }
    }
  }

  func isLoggedIn () -> Bool {
    return CitySessionManager.shared.idToken != nil
  }

  func logout() -> Void {
    CitySessionManager.shared.idToken = nil
    CitySessionManager.shared.accessToken = nil
    CitySessionManager.shared.refreshToken = nil
    DeviceStore.shared.removeDevices();
    UAirship.push()?.updateTags(forUserLoggedIn: false)
    removeProfile()
  }
}
