//
//  TopicHandler.swift
//  CityOSAir
//
//  Created by Andrej Saric on 21/02/2017.
//  Copyright © 2017 CityOS. All rights reserved.
//

/*
 Good - statusGood
 Moderate - statusModerate
 Unhealthy for sensitive - statusSensitive
 Unhealthy - statusUnhealthy
 Very unhealthy - statusVeryUnhealthy
 Hazardous - statusHazardous
 */

struct Topic {
  var name: String
  var topicName: String
  var isSubscribed: Bool
}

struct TopicHandler {

  private static let testFlightTopics = [Topic(name: Text.Settings.AirAlerts.good, topicName: "statusGood_dev", isSubscribed: false),
    Topic(name: Text.Settings.AirAlerts.moderate, topicName: "statusModerate_dev", isSubscribed: false),
    Topic(name: Text.Settings.AirAlerts.sensitive, topicName: "statusSensitive_dev", isSubscribed: false),
    Topic(name: Text.Settings.AirAlerts.unhealthy, topicName: "statusUnhealthy_dev", isSubscribed: false),
    Topic(name: Text.Settings.AirAlerts.veryUnhealthy, topicName: "statusVeryUnhealthy_dev", isSubscribed: false),
    Topic(name: Text.Settings.AirAlerts.hazardous, topicName: "statusHazardous_dev", isSubscribed: false)]

  private static let releaseTopics = [Topic(name: Text.Settings.AirAlerts.good, topicName: "statusGood", isSubscribed: false),
    Topic(name: Text.Settings.AirAlerts.moderate, topicName: "statusModerate", isSubscribed: false),
    Topic(name: Text.Settings.AirAlerts.sensitive, topicName: "statusSensitive", isSubscribed: false),
    Topic(name: Text.Settings.AirAlerts.unhealthy, topicName: "statusUnhealthy", isSubscribed: false),
    Topic(name: Text.Settings.AirAlerts.veryUnhealthy, topicName: "statusVeryUnhealthy", isSubscribed: false),
    Topic(name: Text.Settings.AirAlerts.hazardous, topicName: "statusHazardous", isSubscribed: false)]

  static func getTopicsForSingleDebug() -> [Topic] {

    if let user = UserManager.sharedInstance.getLoggedInUser(), user.email == "john@cityos.io" {
      return testFlightTopics
    } else {
      return releaseTopics
    }
  }

  static func getAllTopics() -> [Topic] {
    return Config.appConfiguration == .testFlight ? testFlightTopics : releaseTopics
  }
}
