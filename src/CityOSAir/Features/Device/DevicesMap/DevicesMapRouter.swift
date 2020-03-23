//
//  MapViewRouter.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 12/17/19.
//  Copyright © 2019 CityOS. All rights reserved.
//

import UIKit

protocol DevicesMapRoutingLogic {
  func navigateToAlert(title: String, message: String, handler: (() -> Void)?)
}

protocol DevicesMapRouterDelegate: class {
  
}

class DevicesMapRouter {
  weak var viewController: DevicesMapViewController?
  weak var delegate: DevicesMapRouterDelegate?
}

// MARK: - Routing Logic
extension DevicesMapRouter: DevicesMapRoutingLogic {
  
  func navigateToAlert(title: String, message: String, handler: (() -> Void)?) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "general_ok".localized(), style: .cancel, handler: { _ in handler?() }))
    viewController?.present(alert, animated: true, completion: nil)
  }
  
}
