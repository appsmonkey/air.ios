//
//  PushExtensions.swift
//  CityOSAir
//
//  Created by Haris Kovacevic on 27/05/2019.
//  Copyright © 2019 CityOS. All rights reserved.
//

import Foundation
import AirshipKit

extension UAPush {
  func updateTags(forUserLoggedIn: Bool) {
    UserDefaults.standard.set(forUserLoggedIn, forKey: "user_logged_in")
    updateTags()
  }

  func updateTags(forSelectedPreference: PushNotificationPreference) {
    let selectedPreference = UserDefaults.standard.integer(forKey: "selected_push_preference")

    if selectedPreference == forSelectedPreference.rawValue {
      UserDefaults.standard.removeObject(forKey: "selected_push_preference")
    } else {
      UserDefaults.standard.set(forSelectedPreference.rawValue, forKey: "selected_push_preference")
    }
    updateTags()
  }

  func updateTags(forLastReceivedTag: [String]) {
    UserDefaults.standard.set(forLastReceivedTag, forKey: "last_received_tags")
    updateTags()
  }

  //  fileprivate func updateTags() {
  //    let previousTags = self.tags
  //
  //    self.removeTags(previousTags)
  //
  //    self.addTag(UserDefaults.standard.bool(forKey: "user_logged_in") ?  "registered_true":"registered_false")
  //
  //    let selectedPushPreference = UserDefaults.standard.integer(forKey:"selected_push_preference")
  //
  //    if selectedPushPreference > 0{
  //      self.addTag((PushNotificationPreference(rawValue: selectedPushPreference)?.tag)!)
  //    }
  //
  //    if let lastReceivedTags = UserDefaults.standard.array(forKey: "last_received_tags") {
  //      self.addTags(lastReceivedTags as! [String])
  //    }
  //
  //    self.updateRegistration()
  //  }

  fileprivate func updateTags() {
    // TODO: this works see if needed to move somewhere else even if it's just a wrapper around user defaults
    let uaChannel = UAChannel(dataStore: UAPreferenceDataStore.init())

    let previousTags = uaChannel.tags

    uaChannel.removeTags(previousTags)
    uaChannel.addTag(UserDefaults.standard.bool(forKey: "user_logged_in") ? "registered_true" : "registered_false")
    let selectedPushPreference = UserDefaults.standard.integer(forKey: "selected_push_preference")
    if selectedPushPreference > 0 {
      uaChannel.addTag((PushNotificationPreference(rawValue: selectedPushPreference)?.tag)!)
    }
    if let lastReceivedTags = UserDefaults.standard.array(forKey: "last_received_tags") {
      uaChannel.addTags(lastReceivedTags as! [String])
    }

    self.updateRegistration()
  }

}

