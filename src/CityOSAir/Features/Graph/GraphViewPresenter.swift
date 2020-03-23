//
//  GraphPresenter.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 12/22/19.
//  Copyright © 2019 CityOS. All rights reserved.
//

import UIKit

protocol GraphViewPresentationLogic {
  func presentGraphError(_ error: Error)
  func presentGraphData(_ readings: [ChartAirReading], period: ReadingPeriod)
}

class GraphViewPresenter {
  weak var viewController: GraphViewDisplayLogic?
}

// MARK: - Presentation Logic
extension GraphViewPresenter: GraphViewPresentationLogic {
  
  func presentGraphData(_ readings: [ChartAirReading], period: ReadingPeriod) {
    viewController?.displayGraphData(for: readings, period: period)
  }
  
  func presentGraphError(_ error: Error) {
    viewController?.displayGraphError(error)
  }
  
}
