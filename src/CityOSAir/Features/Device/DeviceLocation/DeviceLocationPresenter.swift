//
//  DeviceLocationPresenter.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 12/25/19.
//  Copyright © 2019 CityOS. All rights reserved.
//

import UIKit

protocol DeviceLocationPresentationLogic {
  func presentError(_ error: NetworkError)
}

class DeviceLocationPresenter {
  weak var viewController: DeviceLocationDisplayLogic?
}

// MARK: - Presentation Logic
extension DeviceLocationPresenter: DeviceLocationPresentationLogic {
  func presentError(_ error: NetworkError) {
    viewController?.displayError(error)
  }
}
