//
//  MainViewController.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 12/16/19.
//  Copyright © 2019 CityOS. All rights reserved.
//

import UIKit
import SnapKit
import RealmSwift

// MARK: - Display Protocols
protocol MainDisplayLogic: class {
  func displayDeviceInfo(with device: AirDevice)
  func displayAirReadings(_ readings: AirReadings)
  func displayDeviceInfoError(_ error: Error)
}

class MainViewController: UIViewController {
  var interactor: MainBusinessLogic?
  var router: MainRoutingLogic?
  var isFromMapFlow: Bool = false

  lazy var mainContentView = MainContentView.autolayoutView()
  private let mainDataSource = MainDataSource()
  private var refreshControl: UIRefreshControl!

  init(delegate: MainRouterDelegate?) {
    super.init(nibName: nil, bundle: nil)
    let interactor = MainInteractor()
    let presenter = MainPresenter()
    let router = MainRouter()
    interactor.presenter = presenter
    presenter.viewController = self
    router.viewController = self
    router.delegate = delegate
    self.interactor = interactor
    self.router = router

    refreshControl = UIRefreshControl()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    if !isFromMapFlow {
      device = DeviceStore.shared.getMyDevice()
    }

    authService.browserDelegate = self
    slideMenuController()?.delegate = self
    setupViews()

    if device == nil || isFromMapFlow {
      refreshData()
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.isNavigationBarHidden = true

    if AirUserManager.shared.isLoggedIn() {
      authService.browser()
    }
  }

  private func updateDataSource(readings: [AirReading]) {
    mainDataSource.update(readings: readings)
  }

  let authService = CTOSAuthServiceManager()

  var device: AirDevice? {
    didSet {
      guard let device = device else { return }
      mainContentView.headerLabel.text = device.name
      if let oldDevice = oldValue, device.deviceId == oldDevice.deviceId {
        return
      }
      mainContentView.timeStampLabel.text = ""
      refreshData()
    }
  }

  var readingCollection: AirReadings? {
    didSet {
      guard let readingCollection = readingCollection else { return }

      let pm10Value = readingCollection.getReadingValue(type: .pm10)
      let pm25Value = readingCollection.getReadingValue(type: .pm25)

      updateDataSource(readings: readingCollection.readings)
      if mainDataSource.readings.count == 0 {
        mainContentView.tableView.reloadData()
        mainContentView.stopAnimatingLoading()
        mainContentView.timeStampLabel.text = "main_screen_no_data_to_show_label".localized()
        mainContentView.circularGaugeView.refreshToInitial()
        return
      }

      let formatter = DateFormatter()
      formatter.dateStyle = .short
      formatter.timeStyle = .short

      mainContentView.timeStampLabel.text = "\(Text.Readings.subtitle) \(formatter.string(from: readingCollection.lastUpdated))"

      let gaugeConfig = GaugeStates.getConfigForValue(pm10Value: pm10Value ?? -1, pm25Value: pm25Value ?? -1)
      mainContentView.stopAnimatingLoading()
      mainContentView.circularGaugeView.configureWith(config: gaugeConfig.config)

      aqiType = gaugeConfig.aqiType
    }
  }

  var aqiType: AQIType? = nil
  var isRefreshing = false

  @objc
  func openAQIIndex() {
    guard let aqiType = self.aqiType else { return }

    let aqiViewController = AQIViewController()
    aqiViewController.aqiType = aqiType
    self.show(aqiViewController, sender: self)
  }

  func refreshData() {
    if isRefreshing { return }

    mainContentView.startAnimatingLoading()
    isRefreshing = true
    mainContentView.circularGaugeView.refreshToInitial()

    var token: String?
    if let currentDevice = device {
      token = currentDevice.deviceId;
    }

    mainContentView.startAnimatingLoading()
    interactor?.getDeviceWith(token: token ?? "")
  }

  @objc
  func refresh(_ sender: UIRefreshControl) {
    refreshControl = sender
    if isRefreshing { return }

    refreshControl.isEnabled = false
    mainContentView.startAnimatingLoading()
    isRefreshing = true

    if let currentDevice = device {
      let token = currentDevice.deviceId
      interactor?.getDeviceWith(token: token)
    }
  }

  @objc
  func openMenu() {
    self.slideMenuController()?.openLeft()
  }

  @objc
  func openMap() {
    guard let menuViewController = self.slideMenuController()?.leftViewController as? MenuViewController else { return }
    menuViewController.transitionToMap(deviceName: device?.name, isIndoor: device?.indoor)
  }
}

// MARK: - Setup Views
extension MainViewController {
  func setupViews() {
    view.addSubview(mainContentView)

    mainContentView.snp.makeConstraints { $0.edges.equalToSuperview() }

    mainContentView.tableView.delegate = self
    mainContentView.tableView.dataSource = mainDataSource
    mainContentView.tableView.alwaysBounceVertical = true

    mainContentView.refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
    mainContentView.menuButtonTop.addTarget(self, action: #selector(openMenu), for: .touchUpInside)
    mainContentView.mapButtonTop.addTarget(self, action: #selector(openMap), for: .touchUpInside)
    mainContentView.circularGaugeView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openAQIIndex)))
  }
}

// MARK: - UITableViewDelegate
extension MainViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    guard mainDataSource.readings.count > 0 else { return }
    let reading = mainDataSource.readings[indexPath.row]
    if reading.readingType == .waterLevel { return }
    if reading.readingType == .unidentified {
      let identifier = String(reading.type.split(separator: "|")[0])
      if identifier.lowercased() == "motion" { return }
    }
    router?.navigateToGraphView(reading: reading, device: device)
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch indexPath.row {
    case 0, 1:
      return 45 * UIDevice.delta
    default:
      return 40 * UIDevice.delta
    }
  }

  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView.contentOffset.y == 0 || scrollView.contentOffset.y < 0 {
      mainContentView.lineView.isHidden = true
    } else {
      mainContentView.lineView.isHidden = false
    }
  }
}

extension MainViewController: SlideMenuControllerDelegate {
  func startedPan() {
    mainContentView.tableView.isScrollEnabled = false
  }

  func endedPan() {
    mainContentView.tableView.isScrollEnabled = true
  }
}

// MARK: - CTOSAuthServiceBrowserDelegate
extension MainViewController: CTOSAuthServiceBrowserDelegate {

  func didFoundPeer(name: String) {
    let alert = UIAlertController(title: "Do you wish to authorize \(name)?", message: nil, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
      self.authService.connect()
    }))
    alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
    self.present(alert, animated: true, completion: nil)
  }

  func didConnectToPeer() {
    if let user = UserManager.sharedInstance.getLoggedInUser() {
      authService.send(token: user.token)
    }
  }
}

// MARK: - Display Logic
extension MainViewController: MainDisplayLogic {
  func displayDeviceInfo(with device: AirDevice) {
    self.device = device
  }

  func displayAirReadings(_ readings: AirReadings) {
    isRefreshing = false
    if readings.readings.count == 0 {
      mainDataSource.update(readings: [])
      mainContentView.tableView.reloadData()
      mainContentView.stopAnimatingLoading()
      mainContentView.timeStampLabel.text = "main_screen_no_data_yet_to_show_label".localized()
      mainContentView.circularGaugeView.refreshToInitial()
      mainContentView.circularGaugeView.progress.trackColor = .lightGray
      mainContentView.circularGaugeView.progress.progressColors = [.lightGray]
      return
    } else {
      refreshControl.endRefreshing()
      refreshControl.isEnabled = true
      readingCollection = readings
      mainContentView.tableView.reloadData()
      mainContentView.stopAnimatingLoading()
    }
  }

  func displayDeviceInfoError(_ error: Error) {
    refreshControl.endRefreshing()
    refreshControl.isEnabled = true
    isRefreshing = false
    mainContentView.stopAnimatingLoading()
    mainContentView.circularGaugeView.refreshToInitial()
    router?.navigateToAlert(title: "Error", message: "network_error".localized(), handler: nil)
  }

}
