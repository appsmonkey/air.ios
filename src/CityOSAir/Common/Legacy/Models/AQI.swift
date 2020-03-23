//
//  AQI.swift
//  CityOSAir
//
//  Created by Andrej Saric on 29/12/2016.
//  Copyright © 2016 CityOS. All rights reserved.
//

import UIKit

enum AQIType {
  case pm10
  case pm25

  var maxValue: Double {
    switch self {
    case .pm10:
      return 425.0
    case .pm25:
      return 500.4
    }
  }
}

enum AQI: Int {
  case negative = -1
  case zero = 0
  case great
  case ok
  case sensitive
  case unhealthy
  case veryUnhealthy
  case hazardous

  var color: UIColor {
    switch self {
    case .negative:
      return .lightGray
    case .zero:
      return UIColor.black
    case .great:
      return UIColor.fromHex("03d2e2")
    case .ok:
      return UIColor.fromHex("9fd661")
    case .sensitive:
      return UIColor.fromHex("efcc4b")
    case .unhealthy:
      return UIColor.fromHex("fb943d")
    case .veryUnhealthy:
      return UIColor.fromHex("d262ca")
    case .hazardous:
      return UIColor.fromHex("f6453d")
    }
  }

  var textColor: UIColor {
    switch self {
    case .negative:
      return .darkGray
    case .zero:
      return UIColor.black
    case .great:
      return Styles.LabelStates.greatColor
    case .ok:
      return Styles.LabelStates.okColor
    case .sensitive:
      return Styles.LabelStates.sensitiveColor
    case .unhealthy:
      return Styles.LabelStates.unhealthyColor
    case .veryUnhealthy:
      return Styles.LabelStates.veryUnhealthyColor
    case .hazardous:
      return Styles.LabelStates.hazardousColor
    }
  }

  var notation: String {
    switch self {
    default:
      return ReadingType.pm10.unitNotation
    }
  }

  var valuesPM10: String {
    switch self {
    case .negative:
      return ""
    case .zero:
      return ""
    case .great:
      return "0-54"
    case .ok:
      return "54-154"
    case .sensitive:
      return "155-254"
    case .unhealthy:
      return "255-354"
    case .veryUnhealthy:
      return "355-424"
    case .hazardous:
      return "425+"
    }
  }

  var valuesPM25: String {
    switch self {
    case .negative:
      return ""
    case .zero:
      return ""
    case .great:
      return "0-12"
    case .ok:
      return "12.1-35.4"
    case .sensitive:
      return "35.5-55.4"
    case .unhealthy:
      return "55.5-150.4"
    case .veryUnhealthy:
      return "150.5-250.4"
    case .hazardous:
      return "250.5+"
    }
  }

  var image: UIImage {
    switch self {
    case .negative:
      return UIImage()
    case .zero:
      return UIImage()
    case .great:
      return #imageLiteral(resourceName: "status-great")
    case .ok:
      return #imageLiteral(resourceName: "status-ok")
    case .sensitive:
      return #imageLiteral(resourceName: "status-sensitive")
    case .unhealthy:
      return #imageLiteral(resourceName: "status-unhealthy")
    case .veryUnhealthy:
      return #imageLiteral(resourceName: "status-veryunhealthy")
    case .hazardous:
      return #imageLiteral(resourceName: "status-hazardous")
    }
  }

  var message: String {
    switch self {
    case .negative:
      return "main_screen_no_pm_data_to_show_label".localized()
    case .zero:
      return "No data"
    case .great:
      return "Great"
    case .ok:
      return "OK"
    case .sensitive:
      return "Sensitive beware"
    case .unhealthy:
      return "Unhealthy"
    case .veryUnhealthy:
      return "Very Unhealthy"
    case .hazardous:
      return "Hazardous"
    }
  }

  var text: String {
    switch self {
    case .negative:
      return ""
    case .zero:
      return ""
    case .great:
      return "Blue skies! Everyone can enjoy outdoors without risk!"
    case .ok:
      return "Air quality is moderate and only a concern to people extra sensitive to air pollution"
    case .sensitive:
      return "Unhealthy for kids, pregnant women, elderly, active adults, and people with lung disease, asthma. Reduce strenuous outdoor activities."
    case .unhealthy:
      return "Unhealthy for everyone, especially people with heart or lung disease. Everyone should avoid strenuous outdoor activities and wear a mask."
    case .veryUnhealthy:
      return "Unhealthy for everyone, especially people with heart or lung disease. Everyone should avoid physical outdoor activities and wear a mask."
    case .hazardous:
      return "Emergency conditions. Air is hazardous to everyone. Everyone should avoid ALL outdoor activities or wear a mask."
    }
  }

  static func getAQIForTypeWithValue(value: Double?, aqiType: AQIType) -> AQI {

    guard let value = value else {
      return .zero
    }

    if aqiType == .pm10 {

      switch value {
      case -1:
        return .negative
      case 0...54:
        return .great
      case 55...154:
        return .ok
      case 155...254:
        return .sensitive
      case 255...354:
        return .unhealthy
      case 355...424:
        return .veryUnhealthy
      default:
        if value > 424 {
          return .hazardous
        } else {
          return .great
        }
      }

    } else {

      switch value {
      case -1:
        return .zero
      case 0...12:
        return .great
      case 12.1...35.4:
        return .ok
      case 35.5...55.4:
        return .sensitive
      case 55.5...150.4:
        return .unhealthy
      case 150.5...250.4:
        return .veryUnhealthy
      case 250.5...500.4:
        return .hazardous
      default:
        if value > 500.4 {
          return .hazardous
        } else {
          return .great
        }
      }
    }
  }

}


extension AQI {

  var fillColor: UIColor {
    switch self {
    case .negative:
      return .lightGray
    case .zero:
      return UIColor.fromHex("888")
    case .great:
      return UIColor.fromHex("00f0ff")
    case .ok:
      return UIColor.fromHex("9ef83d")
    case .sensitive:
      return UIColor.fromHex("ffea00")
    case .unhealthy:
      return UIColor.fromHex("ffa800")
    case .veryUnhealthy:
      return UIColor.fromHex("ae00ff")
    case .hazardous:
      return UIColor.fromHex("ff0000")
    }
  }

  var strokeColor: UIColor {
    switch self {
    case .negative:
      return .lightGray
    case .zero:
      return UIColor.fromHex("888")
    case .great:
      return UIColor.fromHex("00bfcb")
    case .ok:
      return UIColor.fromHex("47bd00")
    case .sensitive:
      return UIColor.fromHex("ffcc00")
    case .unhealthy:
      return UIColor.fromHex("ffa800")
    case .veryUnhealthy:
      return UIColor.fromHex("ae00ff")
    case .hazardous:
      return UIColor.fromHex("ff0000")
    }
  }
}
