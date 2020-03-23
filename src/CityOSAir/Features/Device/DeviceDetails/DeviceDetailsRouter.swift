//
//  DeviceDetailsRoutter.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 12/25/19.
//  Copyright © 2019 CityOS. All rights reserved.
//

import UIKit

protocol DeviceDetailsRoutingLogic {
  func navigateToDeviceLocation(with payload: AirDevicePayload, mainDeviceAddedProtocol: MainDeviceAddedProtocol?)
  func navigateToAlert(title: String, message: String, handler: (() -> Void)?)
}

protocol DeviceDetailsRouterDelegate: class {
  
}

class DeviceDetailsRouter {
  weak var viewController: DeviceDetailsViewController?
  weak var delegate: DeviceDetailsRouterDelegate?
}

// MARK: - Routing Logic
extension DeviceDetailsRouter: DeviceDetailsRoutingLogic {
  func navigateToDeviceLocation(with payload: AirDevicePayload, mainDeviceAddedProtocol: MainDeviceAddedProtocol?) {
    let controller = DeviceLocationViewController(delegate: nil, mainDeviceAddedProtocol: mainDeviceAddedProtocol)
    controller.devicePayload = payload
    viewController?.navigationController?.pushViewController(controller, animated: true)
  }
  
  func navigateToAlert(title: String, message: String, handler: (() -> Void)?) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "general_ok".localized(), style: .cancel, handler: { _ in handler?() }))
    viewController?.present(alert, animated: true, completion: nil)
  }
}
