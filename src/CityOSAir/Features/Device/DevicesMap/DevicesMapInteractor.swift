//
//  MapViewInteractor.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 12/17/19.
//  Copyright © 2019 CityOS. All rights reserved.
//

import Alamofire

protocol DevicesMapViewBusinessLogic {
  func getMapDataForDevice(type: String)
}

class DevicesMapInteractor {
  var presenter: DevicesMapPresentationLogic?
}

// MARK: - Business Logic
extension DevicesMapInteractor: DevicesMapViewBusinessLogic {

  func getMapDataForDevice(type: String) {
    CityOS.shared.session.request(Router.map(sensor: Constants.Measurement.mapReadingsSensor,
                                             data: Constants.Measurement.mapReadingsData,
                                             type: type)).validate().responseObject {
      (result: Result<Map>, response: DataResponse<Any>) in
      switch result {
      case .success(let response):
        self.presenter?.presentMapData(response.data.devices, mapZones: response.data.zones)
      case .failure(let error):
        self.presenter?.presentMapError(error)
      }
    }
  }

}
