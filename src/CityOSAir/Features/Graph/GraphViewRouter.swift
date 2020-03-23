//
//  GraphRouter.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 12/22/19.
//  Copyright © 2019 CityOS. All rights reserved.
//

import UIKit

protocol GraphViewRoutingLogic {
  func dismiss()
  func navigateToPMIndex(type: ReadingType)
  func alert(_ title:String, message:String?, close: String, closeHandler: ((UIAlertAction) -> Void)?)
}

protocol GraphViewRouterDelegate: class {
  
}

class GraphViewRouter {
  weak var viewController: GraphViewController?
  weak var delegate: GraphViewRouterDelegate?
}

// MARK: - Routing Logic
extension GraphViewRouter: GraphViewRoutingLogic {
  func navigateToPMIndex(type: ReadingType) {
    let aqiViewController = AQIViewController()
    // aqiViewController.modalPresentationStyle = .fullScreen
    if type == .pm10 {
      aqiViewController.aqiType = .pm10
      viewController?.show(aqiViewController, sender: self)
    } else if type == .pm25 {
      aqiViewController.aqiType = .pm25
      viewController?.show(aqiViewController, sender: self)
    }
  }
  
  func dismiss() {
    viewController?.dismiss(animated: true, completion: nil)
  }
  
  func alert(_ title:String, message:String?, close: String, closeHandler: ((UIAlertAction) -> Void)?) {
    func navigateToAlert(title: String, message: String, handler: (() -> Void)?) {
      let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "general_ok".localized(), style: .cancel, handler: { _ in handler?() }))
      viewController?.present(alert, animated: true, completion: nil)
    }
  }
}
