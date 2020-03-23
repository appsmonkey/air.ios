//
//  GraphInteractor.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 12/22/19.
//  Copyright © 2019 CityOS. All rights reserved.
//

import Alamofire

protocol GraphViewBusinessLogic {
  func getChartData(deviceId: String?, period: ReadingPeriod, sensor: String)
}

class GraphViewInteractor {
  var presenter: GraphViewPresentationLogic?
}

// MARK: - Business Logic
extension GraphViewInteractor: GraphViewBusinessLogic {
  
  func getChartData(deviceId: String?, period: ReadingPeriod, sensor: String) {
    let type = deviceId != nil ? ReadingGroup.device : ReadingGroup.all
    CityOS.shared.session.request(Router.chartReadings(period: period, type: type, token: deviceId, sensor: sensor)).validate().responseObject {
      (result: Result<ChartAirReadingContainer>, response: DataResponse<Any>) in
      switch result {
      case .success(let readings):
        self.presenter?.presentGraphData(readings.data, period: period)
      case .failure(let error):
        log.info(error)
        self.presenter?.presentGraphError(error)
      }
    }
  }
}
