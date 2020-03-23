//
//  MapViewPresenter.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 12/17/19.
//  Copyright © 2019 CityOS. All rights reserved.
//

import UIKit

protocol DevicesMapPresentationLogic {
  func presentMapError(_ error: Error)
  func presentMapData(_ devices: [AirDevice], mapZones: [Zone])
}

class DevicesMapPresenter {
  weak var viewController: DevicesMapDisplayLogic?
}

// MARK: - Presentation Logic
extension DevicesMapPresenter: DevicesMapPresentationLogic {
  
  func presentMapData(_ devices: [AirDevice], mapZones: [Zone]) {
    viewController?.displayMapData(for: devices, mapZones: mapZones)
  }
  
  func presentMapError(_ error: Error) {
    viewController?.displayMapError(error)
  }
  
}
