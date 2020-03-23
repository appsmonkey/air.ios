//
//  ConfigureDeviceRouter.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 12/25/19.
//  Copyright © 2019 CityOS. All rights reserved.
//

import UIKit

protocol ConfigureDeviceRoutingLogic {
  func navigateToDeviceLocation(with payload: AirDevicePayload, mainDeviceAddedProtocol: MainDeviceAddedProtocol?)
  func navigateToSettings()
  func navigateToAlert(title: String, message: String, handler: (() -> Void)?)
}

protocol ConfigureDeviceRouterDelegate: class {
  
}

class ConfigureDeviceRouter {
  weak var viewController: ConfigureDeviceViewController?
  weak var delegate: ConfigureDeviceRouterDelegate?
}

// MARK: - Routing Logic
extension ConfigureDeviceRouter: ConfigureDeviceRoutingLogic {
  func navigateToDeviceLocation(with payload: AirDevicePayload, mainDeviceAddedProtocol: MainDeviceAddedProtocol?) {
    let controller = DeviceLocationViewController(delegate: nil, mainDeviceAddedProtocol: mainDeviceAddedProtocol)
    controller.devicePayload = payload
    viewController?.navigationController?.pushViewController(controller, animated: true)
  }
  
  func navigateToSettings() {
    if let url = URL(string: UIApplication.openSettingsURLString) {
      if UIApplication.shared.canOpenURL(url) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
      }
    }
  }
  
  func navigateToAlert(title: String, message: String, handler: (() -> Void)?) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "general_ok".localized(), style: .cancel, handler: { _ in handler?() }))
    viewController?.present(alert, animated: true, completion: nil)
  }
}
