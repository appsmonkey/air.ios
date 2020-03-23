//
//  GaugeStates.swift
//  CityOSAir
//
//  Created by Andrej Saric on 05/01/2017.
//  Copyright © 2017 CityOS. All rights reserved.
//

import UIKit

struct GaugeStates {
  static let noData = GaugeConfig(progressColor: .lightGray,
    maxValue: 0,
    progressValue: 0,
    ribbonText: "main_screen_no_pm_data_to_show_label".localized(),
    ribbonImage: UIImage(named: "ribbon-ok")!.filled(with: .lightGray),
    centerImage: UIImage(), aqi: .negative)

  static let great = GaugeConfig(progressColor: Styles.DetailStates.greatColor,
    maxValue: 500,
    progressValue: 300,
    ribbonText: Text.Ribbons.great,
    ribbonImage: #imageLiteral(resourceName: "ribbon-great"),
    centerImage: #imageLiteral(resourceName: "status-great-black"),
    aqi: .great)

  static let ok = GaugeConfig(progressColor: Styles.DetailStates.okColor,
    maxValue: 500,
    progressValue: 300,
    ribbonText: Text.Ribbons.ok,
    ribbonImage: #imageLiteral(resourceName: "ribbon-ok"),
    centerImage: #imageLiteral(resourceName: "status-ok-black"),
    aqi: .ok)

  static let sensitive = GaugeConfig(progressColor: Styles.DetailStates.sensitiveColor,
    maxValue: 500,
    progressValue: 300,
    ribbonText: Text.Ribbons.sensitive,
    ribbonImage: #imageLiteral(resourceName: "ribbon-sensitive"),
    centerImage: #imageLiteral(resourceName: "status-sensitive-black"),
    aqi: .sensitive)

  static let unhealthy = GaugeConfig(progressColor: Styles.DetailStates.unhealthyColor,
    maxValue: 500,
    progressValue: 300,
    ribbonText: Text.Ribbons.unhealthy,
    ribbonImage: #imageLiteral(resourceName: "ribbon-unhealthy"),
    centerImage: #imageLiteral(resourceName: "status-unhealthy-black"),
    aqi: .unhealthy)

  static let veryUnhealthy = GaugeConfig(progressColor: Styles.DetailStates.veryUnhealthyColor,
    maxValue: 500,
    progressValue: 300,
    ribbonText: Text.Ribbons.veryUnhealthy,
    ribbonImage: #imageLiteral(resourceName: "ribbon-veryunhealthy"),
    centerImage: #imageLiteral(resourceName: "status-veryunhealthy-black"),
    aqi: .veryUnhealthy)

  static let hazardous = GaugeConfig(progressColor: Styles.DetailStates.hazardousColor,
    maxValue: 500,
    progressValue: 300,
    ribbonText: Text.Ribbons.hazardous,
    ribbonImage: #imageLiteral(resourceName: "ribbon-hazardous"),
    centerImage: #imageLiteral(resourceName: "status-hazardous-black"),
    aqi: .hazardous)

  static func getConfigForValue(pm10Value: Double, pm25Value: Double) -> (config: GaugeConfig, aqiType: AQIType) {

    let pm10Aqi = AQI.getAQIForTypeWithValue(value: pm10Value, aqiType: .pm10)
    let pm25Aqi = AQI.getAQIForTypeWithValue(value: pm25Value, aqiType: .pm25)


    var aqiToUse: AQI
    var valueToUse: Double
    var maxValue: Double
    var config: GaugeConfig
    var aqiType: AQIType

    if pm10Aqi.rawValue > pm25Aqi.rawValue {
      aqiToUse = pm10Aqi
      aqiType = .pm10
      valueToUse = pm10Value
      maxValue = AQIType.pm10.maxValue
    } else {
      aqiToUse = pm25Aqi
      aqiType = .pm25
      valueToUse = pm25Value
      maxValue = AQIType.pm25.maxValue
    }

    if pm10Value == -1 && pm25Value == -1 {
      aqiToUse = .negative
    }

    switch aqiToUse {
    case .negative:
      config = noData
    case .zero:
      config = great
    case .great:
      config = great
    case .ok:
      config = ok
    case .sensitive:
      config = sensitive
    case .unhealthy:
      config = unhealthy
    case .veryUnhealthy:
      config = veryUnhealthy
    case .hazardous:
      config = hazardous
    }

    config.maxValue = maxValue
    config.progressValue = valueToUse
    
    return (config, aqiType)
  }
}
