//
//  ConnectDevicePresenter.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 12/19/19.
//  Copyright © 2019 CityOS. All rights reserved.
//

import UIKit

protocol ConnectDevicePresentationLogic {
  func presentError(_ error: Error)
  func presentDevice(token: String)
}

class ConnectDevicePresenter {
  weak var viewController: ConnectDeviceDisplayLogic?
}

// MARK: - Presentation Logic
extension ConnectDevicePresenter: ConnectDevicePresentationLogic {
  
  func presentError(_ error: Error) {
    viewController?.displayError(error)
  }
  
  func presentDevice(token: String) {
    viewController?.displayDevice(token: token)
  }
  
}
