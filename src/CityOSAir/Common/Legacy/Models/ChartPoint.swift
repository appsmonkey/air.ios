//
//  ChartPoint.swift
//  CityOSAir
//
//  Created by Andrej Saric on 03/09/16.
//  Copyright © 2016 CityOS. All rights reserved.
//

import Foundation

struct ChartPoint {

  var xLabel: String {
    get {
      if let date = self.date {
        return date.dateToXAxisTimestamp()
      }

      return ""
    }
  }

  //var timeframe: Timeframe
  var value: Double
  var date: Date?

  init(value: Double, timestamp: Int) {
    self.value = value
    self.date = Date(timeIntervalSince1970: TimeInterval(timestamp))
  }

  init(json: JSON) {
    //self.timeframe = timeframe
    date = json["date"].string?.dateFromString()
    value = json["value"].doubleValue
  }

  init(chartPoint: ChartPoint) {
    //self.timeframe = chartPoint.timeframe
    self.date = chartPoint.date
    self.value = chartPoint.value
  }
}
