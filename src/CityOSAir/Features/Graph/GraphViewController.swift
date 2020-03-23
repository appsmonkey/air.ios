//
//  GraphViewController.swift
//  CityOSAir
//
//  Created by Andrej Saric on 29/08/16.
//  Copyright © 2016 CityOS. All rights reserved.
//

import UIKit

// MARK: - Display Protocols
protocol GraphViewDisplayLogic: class {
  func displayGraphError(_ error: Error)
  func displayGraphData(for readings: [ChartAirReading], period: ReadingPeriod)
}

class GraphViewController: UIViewController {

  var interactor: GraphViewBusinessLogic?
  var router: GraphViewRoutingLogic?

  lazy var graphContentView = GraphContentView().autolayoutView()

  var reading: AirReading
  var device: AirDevice?
  var selectedBtn = 0

  // MARK: - View Cycle
  init(delegate: GraphViewRouterDelegate?, device: AirDevice?, reading: AirReading) {
    self.reading = reading
    self.device = device

    super.init(nibName: nil, bundle: nil)
    let interactor = GraphViewInteractor()
    let presenter = GraphViewPresenter()
    let router = GraphViewRouter()
    interactor.presenter = presenter
    presenter.viewController = self
    router.viewController = self
    router.delegate = delegate
    self.interactor = interactor
    self.router = router
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    loadChartData(period: .live)

    setupViews()
    graphContentView.setupReadings()
  }

  func setupViews() {
    view.addSubview(graphContentView)

    graphContentView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    graphContentView.closeButtonTop.addTarget(self, action: #selector(GraphViewController.closePressed), for: .touchUpInside)

    graphContentView.reading = reading
    graphContentView.setupChartView()
    graphContentView.setupStackView()
    graphContentView.stackView.subviews.forEach { (view) in
      if let button = view as? UIButton {
        button.addTarget(self, action: #selector(GraphViewController.timeFrameChanged(sender:)), for: .touchUpInside)
      }
    }

    let stateLabelTap = UITapGestureRecognizer(target: self, action: #selector(stateLabelTapped))
    graphContentView.stateLabel.isUserInteractionEnabled = true
    graphContentView.stateLabel.addGestureRecognizer(stateLabelTap)
  }

  @objc
  func stateLabelTapped() {
    log.info("state label tapped")
    router?.navigateToPMIndex(type: reading.readingType)
  }

  @objc
  func timeFrameChanged(sender: UIButton) {
    if selectedBtn == sender.tag { return }

    graphContentView.addChartView()
    selectedBtn = sender.tag

    for btn in graphContentView.stackView.arrangedSubviews {
      btn.backgroundColor = .clear
    }

    UIView.animate(withDuration: 0.5) {
      sender.backgroundColor = UIColor.fromHex("f5f5f5")
    }

    graphContentView.chartView.clear()
    loadChartData(period: ReadingPeriod.init(rawValue: selectedBtn)!)
  }

  @objc func closePressed() {
    self.dismiss(animated: true, completion: nil)
  }

  func loadChartData(period: ReadingPeriod) {
    let deviceId = device?.deviceId == "" ? nil : device?.deviceId
    interactor?.getChartData(deviceId: deviceId, period: period, sensor: reading.sensorId)
  }

}

// MARK: - Display Protocols Implementation
extension GraphViewController: GraphViewDisplayLogic {
  func displayGraphError(_ error: Error) {
    router?.alert("error".localized(), message: "network_error".localized(), close: "ok".localized(), closeHandler: nil)
  }

  func displayGraphData(for readings: [ChartAirReading], period: ReadingPeriod) {
    let points: [ChartPoint] = readings.map { ChartPoint(value: $0.value, timestamp: $0.date) }.sorted { (point1, point2) -> Bool in
      point1.date! < point2.date!
    }
    graphContentView.chartView.setChart(chartPoints: points, readingType: reading.readingType, timeframe: period)
  }
}
