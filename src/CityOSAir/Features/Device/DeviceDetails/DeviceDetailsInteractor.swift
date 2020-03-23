//
//  DeviceDetailsInteractor.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 12/25/19.
//  Copyright © 2019 CityOS. All rights reserved.
//

import Alamofire
import Crashlytics

protocol DeviceDetailsBusinessLogic {
  func addDevice(request: AddDeviceRequest)
}

class DeviceDetailsInteractor {
  var presenter: DeviceDetailsPresentationLogic?
}

// MARK: - Business Logic
extension DeviceDetailsInteractor: DeviceDetailsBusinessLogic {
  func addDevice(request: AddDeviceRequest) {
    if !ConnectivityManager.shared.isConnected() {
      self.presenter?.presentError(NetworkError.General("Failed to add device. Check Internet Connection."))
    } else {
      CityOS.shared.session.request(Router.addDevice(request: request)).validate().responseObject {
        (result: Result<AddDeviceResponse>, response: DataResponse<Any>) in
        switch result {
        case .success(let response):
          self.presenter?.presentMainScreen(with: response.data.token)
        case .failure(let error):
          Crashlytics.sharedInstance().recordError(error)
          self.presenter?.presentError(NetworkError.General("Failed to add device. Error has been recorded."))
        }
      }
    }
  }

}
