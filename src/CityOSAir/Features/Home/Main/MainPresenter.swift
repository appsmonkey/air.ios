//
//  MainPresenter.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 12/16/19.
//  Copyright © 2019 CityOS. All rights reserved.
//

import UIKit

protocol MainPresentationLogic {
  func presentDevice(with device: AirDevice)
  func pesentAirReadings(_ readings: AirReadings)
  func presentDeviceInfoError(_ error: Error)
}

class MainPresenter {
  weak var viewController: MainDisplayLogic?
}

// MARK: - Presentation Logic
extension MainPresenter: MainPresentationLogic {
  func presentDevice(with device: AirDevice) {
    viewController?.displayDeviceInfo(with: device)
  }
  
  func pesentAirReadings(_ readings: AirReadings) {
    viewController?.displayAirReadings(readings)
  }

  func presentDeviceInfoError(_ error: Error) {
    viewController?.displayDeviceInfoError(error)
  }
}
