//
//  DeviceDetailsPresenter.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 12/25/19.
//  Copyright © 2019 CityOS. All rights reserved.
//

import UIKit

protocol DeviceDetailsPresentationLogic {
  func presentMainScreen(with token: String)
  func presentError(_ error: NetworkError)
}

class DeviceDetailsPresenter {
  weak var viewController: DeviceDetailsDisplayLogic?
}

// MARK: - Presentation Logic
extension DeviceDetailsPresenter: DeviceDetailsPresentationLogic {
  func presentMainScreen(with token: String) {
    viewController?.displayMainSceren(with: token)
  }
  
  func presentError(_ error: NetworkError) {
    viewController?.displayError(error)
  }
}
