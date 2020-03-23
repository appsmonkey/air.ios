//
//  DeviceLocationRouter.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 12/25/19.
//  Copyright © 2019 CityOS. All rights reserved.
//

import UIKit

protocol DeviceLocationRoutingLogic {
  func navigateToAlert(title: String, message: String, handler: (() -> Void)?)
  func navigateToDeviceDetails(payload: AirDevicePayload, mainDeviceAddedProtocol: MainDeviceAddedProtocol?)
  func popToRootViewController()
}

protocol DeviceLocationRouterDelegate: class {
  
}

class DeviceLocationRouter {
  weak var viewController: DeviceLocationViewController?
  weak var delegate: DeviceLocationRouterDelegate?
}

// MARK: - Routing Logic
extension DeviceLocationRouter: DeviceLocationRoutingLogic {
  func navigateToDeviceDetails(payload: AirDevicePayload, mainDeviceAddedProtocol: MainDeviceAddedProtocol?) {
    let controller = DeviceDetailsViewController(delegate: nil, mainDeviceAddedProtocol: mainDeviceAddedProtocol)
    controller.devicePayload = payload
    viewController?.navigationController?.pushViewController(controller, animated: true)
  }
  
  func popToRootViewController() {
    viewController?.navigationController?.popToRootViewController(animated: true)
  }
  
  func navigateToAlert(title: String, message: String, handler: (() -> Void)?) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "general_ok".localized(), style: .cancel, handler: { _ in handler?() }))
    viewController?.present(alert, animated: true, completion: nil)
  }
}
