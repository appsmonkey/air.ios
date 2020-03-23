//
//  ConnectDeviceInteractor.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 12/19/19.
//  Copyright © 2019 CityOS. All rights reserved.
//

import Alamofire

protocol ConnectDeviceBusinessLogic {
  func getDeviceToken()
}

class ConnectDeviceInteractor {
  var presenter: ConnectDevicePresentationLogic?
}

// MARK: - Business Logic
extension ConnectDeviceInteractor: ConnectDeviceBusinessLogic {

  func getDeviceToken() {
    let request = Alamofire.request("http://192.168.4.1/id")
    request.responseObject {
      (result: Result<DeviceTokenResponse>, response: DataResponse<Any>) in
      switch result {
      case .success(let response):
        log.info(response)
        self.presenter?.presentDevice(token: response.thingName)
      case .failure(let error):
        self.presenter?.presentError(error)
      }
    }
  }

}
