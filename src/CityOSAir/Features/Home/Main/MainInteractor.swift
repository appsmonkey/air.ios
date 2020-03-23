//
//  MainInteactor.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 12/16/19.
//  Copyright © 2019 CityOS. All rights reserved.
//

import Alamofire

protocol MainBusinessLogic {
  func getDeviceWith(token: String)
}

class MainInteractor {
  var presenter: MainPresentationLogic?
}

// MARK: - Business Logic
extension MainInteractor: MainBusinessLogic {
  func getDeviceWith(token: String) {
    CityOS.shared.session.request(Router.device(token: token)).validate().responseObject {
      (result: Result<DeviceResponse>, response: DataResponse<Any>) in
      switch result {
      case .success(let deviceResponse):
        log.debug(deviceResponse)
        let data = deviceResponse.data
        let device = AirDevice(deviceId: data.deviceId, name: data.name, active: data.active, model: data.model, indoor: data.indoor, mine: data.mine)
        self.presenter?.presentDevice(with: device)
        let readings = ReadingParser.shared.parse(data: data.latest ?? [String: Double]())
        let airReadings = AirReadings(readings: readings, lastUpdated: data.timestamp)
        self.presenter?.pesentAirReadings(airReadings)
      case .failure(let error):
        log.error(error)
        self.presenter?.presentDeviceInfoError(error)
      }
    }
  }
  
}
