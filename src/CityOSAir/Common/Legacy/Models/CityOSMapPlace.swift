//
//  CityOSMapPlace.swift
//  CityOSAir
//
//  Created by Andrej Saric on 17/04/2017.
//  Copyright © 2017 CityOS. All rights reserved.
//

import Foundation


class CTOSPlaceHandler {
  static func getPlaces(city: String) -> [CTOSMapPlace] {
    var places: [CTOSMapPlace] = []
    guard let filePath = Bundle.main.path(forResource: "places\(city)", ofType: "json") else { fatalError("Places Json File is missing") }

    do {
      let contents = try String(contentsOfFile: filePath)
      let json = JSON(parseJSON: contents)//JSON(contents)
      for innerJson in json.arrayValue {
        let place = CTOSMapPlace(json: innerJson)
        places.append(place)
      }
    } catch {
      log.error(error)
    }

    return places
  }
}

class CTOSMapPlace {

  let title: String
  var polygon: [MapLocation]

  init(json: JSON) {

    title = json["title"].stringValue
    polygon = []

    for innerJson in json["polygon"].arrayValue {
      let poly = MapLocation(forPolyWithJson: innerJson)
      polygon.append(poly)
    }

  }
}

class MapLocation {

  var latitude: Double
  var longitude: Double

  init(forPolyWithJson json: JSON) {

    latitude = json["lat"].doubleValue
    longitude = json["lng"].doubleValue
  }

  init(forDeviceWithJson json: JSON) {

    latitude = json["latitude"].doubleValue
    longitude = json["longitude"].doubleValue
  }

}
