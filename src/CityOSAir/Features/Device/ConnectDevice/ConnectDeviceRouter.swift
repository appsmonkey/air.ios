//
//  ConnectDeviceRouter.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 12/19/19.
//  Copyright © 2019 CityOS. All rights reserved.
//

import UIKit

protocol ConnectDeviceRoutingLogic {
  func navigateToConfigureDeviceScreen(token: String, mainDeviceAddedProtocol: MainDeviceAddedProtocol?)
  func navigateToSettings()
  func navigateToAlert(title: String, message: String, handler: (() -> Void)?)
}

protocol ConnectDeviceRouterDelegate: class {
  
}

class ConnectDeviceRouter {
  weak var viewController: ConnectDeviceViewController?
  weak var delegate: ConnectDeviceRouterDelegate?
}

// MARK: - Routing Logic
extension ConnectDeviceRouter: ConnectDeviceRoutingLogic {
  func navigateToConfigureDeviceScreen(token: String, mainDeviceAddedProtocol: MainDeviceAddedProtocol?) {
    let devicePayload = AirDevicePayload(token: token, name: "Boxy", coordinates: LatLng(), model: "Boxy", indoor: false, city: "Sarajevo")
    let controller = ConfigureDeviceViewController(delegate: nil, mainDeviceAddedProtocol: mainDeviceAddedProtocol)
    controller.devicePayload = devicePayload
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
