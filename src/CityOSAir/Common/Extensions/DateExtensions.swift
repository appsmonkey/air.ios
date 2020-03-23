//
//  DateExtensions.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 11/28/19.
//  Copyright © 2019 CityOS. All rights reserved.
//

import Foundation

extension Date {

  func toLocalTime() -> Date {
    let timezone: TimeZone = TimeZone.autoupdatingCurrent
    let seconds: TimeInterval = TimeInterval(timezone.secondsFromGMT(for: self))
    let local = Date(timeInterval: seconds, since: self)
    return local
  }

  func isToday() -> Bool {
    let cal = Calendar.current
    var components = (cal as NSCalendar).components([.era, .year, .month, .day], from: Date())
    let today = cal.date(from: components)!

    components = (cal as NSCalendar).components([.era, .year, .month, .day], from: self)
    let otherDate = cal.date(from: components)!

    return (today == otherDate)
  }

  func isSameHourAs(_ date: Date) -> Bool {

    let cal = Calendar.current
    var components = (cal as NSCalendar).components([.era, .year, .month, .day, .hour], from: date)
    let second = cal.date(from: components)!

    components = (cal as NSCalendar).components([.era, .year, .month, .day, .hour], from: self)
    let first = cal.date(from: components)!

    return (first == second)
  }

  func dateToXAxisTimestamp() -> String {

    let formatter = DateFormatter()

    if let regionCode = Locale.current.regionCode, regionCode != "US" {
      formatter.locale = Locale(identifier: "en_US_POSIX")
      formatter.dateFormat = "d, MMM HH:mm"
    } else {
      formatter.locale = Locale(identifier: "en_US_POSIX")
      formatter.dateFormat = "MMM d HH:mm"
    }

    return formatter.string(from: self)
  }

  func toString() -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .full
    formatter.timeStyle = .full
    return formatter.string(from: self)
  }
}
