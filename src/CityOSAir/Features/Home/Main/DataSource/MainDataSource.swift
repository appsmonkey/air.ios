//
//  DeviceInfoDataSource.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 12/1/19.
//  Copyright © 2019 CityOS. All rights reserved.
//

import UIKit

class MainDataSource: NSObject, DataSource {
  var sections = [AirReadingSection]()
  var readings: [AirReading] = []
  
  weak var target: MainViewController?
  
  func update(readings: [AirReading]) {
    self.readings = readings
    buildSections()
  }
}

extension MainDataSource: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return readings.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let reading = readings[indexPath.row]
    var cell = UITableViewCell()
    var shouldDisable = false
    
    if reading.readingType == .waterLevel { shouldDisable = true }
    if reading.readingType == .unidentified {
      let identifier = String(reading.type.split(separator: "|")[0])
      if identifier.lowercased() == "motion" { shouldDisable = true }
    }
    
    var readingValue = String(reading.value)
    if reading.readingType != .batteryVoltage {
      let doubleToString = "\(readingValue)"
      let stringToInteger = (doubleToString as NSString).integerValue
      readingValue = String(stringToInteger)
    }
    
    if reading.readingType == .pm25 || reading.readingType == .pm10 {
      let aqiType = reading.readingType == .pm25 ? AQIType.pm25 : AQIType.pm10
      let aqi = AQI.getAQIForTypeWithValue(value: reading.value.roundTo(places: 1), aqiType: aqiType)
      cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as ExtendedReadingTableViewCell
      (cell as! ExtendedReadingTableViewCell).configure(reading.readingType, aqi: aqi, value: readingValue)
      (cell as! ExtendedReadingTableViewCell).rightArrow.isHidden = shouldDisable
      (cell as! ExtendedReadingTableViewCell).rightConstraint.isActive = shouldDisable
    } else {
      cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as ReadingTableViewCell
      (cell as! ReadingTableViewCell).configure(reading, value: readingValue)
      (cell as! ReadingTableViewCell).rightArrow.isHidden = shouldDisable
      (cell as! ReadingTableViewCell).rightConstraint.isActive = shouldDisable
    }
    
    if shouldDisable {
      cell.selectionStyle = .none
    } else {
      
    }
    
    return cell
  }

}

// MARK: - Private Methods

private extension MainDataSource {
  func buildSections() {
    sortReadings()
  }
  
  func sortReadings() {
    guard let pm25 = readings.filter({ $0.readingType == ReadingType.pm25 }).first,
      let pm25Index = readings.firstIndex(where: { $0 === pm25 }) else {
        return
    }
    
    if pm25Index != 0 {
      readings.swapAt(0, pm25Index)
    }
    
    guard let pm10 = readings.filter({ $0.readingType == ReadingType.pm10 }).first,
      let pm10Index = readings.firstIndex(where: { $0 === pm10 }) else {
        return
    }
    
    if pm10Index != 1 {
      readings.swapAt(1, pm10Index)
    }

  }
  
  func rearrange<T>(array: Array<T>, fromIndex: Int, toIndex: Int) -> Array<T> {
    var arr = array
    let element = arr.remove(at: fromIndex)
    arr.insert(element, at: toIndex)
    
    return arr
  }
}

