//
//  MainRouter.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 12/16/19.
//  Copyright © 2019 CityOS. All rights reserved.
//

import UIKit

protocol MainRoutingLogic {
  func navigateToMap()
  func navigateToGraphView(reading: AirReading, device: AirDevice?)
  func navigateToAlert(title: String, message: String, handler: (() -> Void)?)
}

protocol MainRouterDelegate: class {
  
}

class MainRouter {
  weak var viewController: MainViewController?
  weak var delegate: MainRouterDelegate?
}

// MARK: - Routing Logic
extension MainRouter: MainRoutingLogic {
  func navigateToMap() {
    let mapController = DevicesMapViewController(delegate: nil)
    viewController?.navigationController?.pushViewController(mapController, animated: true)
  }
  
  func navigateToGraphView(reading: AirReading, device: AirDevice?) {
    let graphViewController = GraphViewController(delegate: nil, device: device, reading: reading)
    graphViewController.modalPresentationStyle = .fullScreen
    viewController?.present(graphViewController, animated: true, completion: nil)
  }
  
  func navigateToAlert(title: String, message: String, handler: (() -> Void)?) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "general_ok".localized(), style: .cancel, handler: { _ in handler?() }))
    viewController?.present(alert, animated: true, completion: nil)
  }
}
