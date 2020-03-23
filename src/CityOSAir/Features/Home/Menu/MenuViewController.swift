//
//  MenuViewController.swift
//  CityOSAir
//
//  Created by Andrej Saric on 27/12/2016.
//  Copyright © 2016 CityOS. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire

// MARK: - DeviceAddedProtocol
protocol MainDeviceAddedProtocol {
  func deviceAdded(with token: String)
}

class MenuViewController: UIViewController, Progressable {

  lazy var closeBtn: UIButton = {
    let btn = UIButton()
    btn.setImage(UIImage(named: "close"), for: UIControl.State())
    btn.translatesAutoresizingMaskIntoConstraints = false
    btn.addTarget(self, action: #selector(MenuViewController.closePressed), for: .touchUpInside)
    return btn
  }()

  lazy var tableView: UITableView = {
    let table = UITableView()
    table.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    table.dataSource = self
    table.delegate = self
    table.tableFooterView = UIView()
    table.separatorStyle = .none
    table.alwaysBounceVertical = false
    table.bounces = false
    table.translatesAutoresizingMaskIntoConstraints = false
    table.backgroundColor = .clear
    return table
  }()

  var first = [MenuCells.cityMap, MenuCells.cityAir]
  var second = [MenuCells.aqiPM10, MenuCells.aqiPM25, MenuCells.settings]
  var allDevices: [String] = []

  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .black

    Cache.sharedCache.delegate = self
    setupSections()
    setupViews()
  }

  override func viewWillAppear(_ animated: Bool) {
    setupSections()
    tableView.reloadData()
  }

  func setupSections() {
    first = []
    second = [MenuCells.aqiPM10, MenuCells.aqiPM25, MenuCells.settings]

    if AirUserManager.shared.isLoggedIn() {
      second.insert(MenuCells.addDevice, at: 0)
      second.append(MenuCells.deviceRefresh)

      if let devices = DeviceStore.shared.getMyDevices() {
        for device in sortDevices(devices) {

          if device.name == MenuCells.cityAir.text {
            allDevices.append(MenuCells.cityAir.text)
            continue
          }

          allDevices.append(device.name)
          first.append(MenuCells.cityDevice(name: device.name))
        }
      }
    } else {
      second.insert(MenuCells.logIn, at: 0)
    }

    first.append(contentsOf: [MenuCells.cityAir, MenuCells.cityMap])
  }
  
  func sortDevices(_ devices: [AirDevice]) -> [AirDevice] {
    var sortedDevices = [AirDevice]()
    
    let indoorDevices = devices.filter { $0.indoor && $0.name !=  MenuCells.cityAir.text }.sorted { $0.name.lowercased() < $1.name.lowercased() }
    let outdoorDevices = devices.filter { !$0.indoor && $0.name !=  MenuCells.cityAir.text }.sorted { $0.name.lowercased() < $1.name.lowercased() }
    
    sortedDevices.append(contentsOf: outdoorDevices)
    sortedDevices.append(contentsOf: indoorDevices)
    
    return sortedDevices
  }

  func setupViews() {
    view.addSubview(closeBtn)
    view.addSubview(tableView)

    closeBtn.snp.makeConstraints { (make) -> Void in
      make.centerX.equalTo(view)
      make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
      make.height.width.equalTo(30)
    }

    tableView.snp.makeConstraints { (make) -> Void in
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      make.bottom.equalTo(closeBtn.snp.top)
      make.left.right.equalTo(view)
    }

  }

  @objc func closePressed() {
    self.slideMenuController()?.closeLeft()
  }
}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {

  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return section == 0 ? first.count : second.count
  }

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return section == 0 ? 20 : 40
  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let view = UIView()
    view.backgroundColor = .clear
    return view
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

    cell.indentationWidth = 15
    cell.indentationLevel = 1
    //        cell.selectionStyle = .none
    cell.backgroundColor = .clear

    if indexPath.section == 0 {
      cell.textLabel?.font = Styles.MenuButtonBig.font
      cell.textLabel?.textColor = Styles.MenuButtonBig.tintColor
    } else {
      cell.textLabel?.font = Styles.MenuButtonSmall.font
      cell.textLabel?.textColor = Styles.MenuButtonSmall.tintColor
    }

    cell.textLabel?.adjustsFontSizeToFitWidth = true
    cell.accessoryType = .none

    return cell
  }

  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

    if indexPath.section == 0 {
      let text = first[indexPath.row].text.truncate(length: 30)
      if slideMenuController()?.mainViewController as? DevicesMapViewController != nil && text == MenuCells.cityMap.text {
        cell.textLabel?.text = text
        cell.textLabel?.textColor = Styles.MenuButtonBig.choosenTintColor
        return
      }

      guard let current = self.slideMenuController()?.mainViewController as? MainViewController,
        let title = current.mainContentView.headerLabel.text else {
          cell.textLabel?.text = text
          return
      }

      if title == text {
        cell.textLabel?.textColor = Styles.MenuButtonBig.choosenTintColor
      }

      cell.textLabel?.text = text
    } else {
      switch second[indexPath.row] {
      case .aqiPM25:
        let attributedText = NSMutableAttributedString(string: second[indexPath.row].text,
                                                       attributes: [NSAttributedString.Key.font: Styles.MenuButtonSmall.font])
        attributedText.setAttributes([NSAttributedString.Key.font: Styles.MenuButtonSmall.subscriptFont,
                                      NSAttributedString.Key.baselineOffset: -8],
                                     range: NSRange(location: 2, length: 3))
        cell.textLabel?.attributedText = attributedText
        return
      default:
        break
      }
      cell.textLabel?.text = second[indexPath.row].text
    }
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let data = indexPath.section == 0 ? first : second

    switch data[indexPath.row] {
    case .aqiPM10:
      let aqiViewController = AQIViewController()
      aqiViewController.modalPresentationStyle = .fullScreen
      aqiViewController.aqiType = .pm10
      show(aqiViewController, sender: self)
    case .aqiPM25:
      let aqiViewController = AQIViewController()
      aqiViewController.modalPresentationStyle = .fullScreen
      aqiViewController.aqiType = .pm25
      show(aqiViewController, sender: self)
    case .settings:
      let settingsViewController = UINavigationController(rootViewController: SettingsViewController())
      settingsViewController.modalPresentationStyle = .fullScreen
      settingsViewController.isNavigationBarHidden = true
      present(settingsViewController, animated: true)
    case .logIn:
      let loginViewcontroller = LoginViewController(delegate: self)
      loginViewcontroller.shouldClose = true
      let navigationController = UINavigationController(rootViewController: loginViewcontroller)
      navigationController.modalPresentationStyle = .fullScreen
      present(navigationController, animated: true)
    case .cityDevice(let name):
      transitionToDevice(name: name)
    case .cityAir:
      transitionToCity()
    case .deviceRefresh:
      refreshDevices()
    case .cityMap:
      transitionToMap()
    case .addDevice:
      connectDevice()
    }
  }

  func connectDevice() {
    closePressed()
    let connectDeviceViewController = ConnectDeviceViewController(delegate: nil, mainDeviceAddedProtocol: self)
//    let connectDeviceViewController = DeviceLocationViewController(delegate: nil, mainDeviceAddedProtocol: self)
    let navigationController = UINavigationController(rootViewController: connectDeviceViewController)
    navigationController.modalPresentationStyle = .fullScreen
    present(navigationController, animated: true)
  }

  func transitionToMap(deviceName: String? = "", isIndoor: Bool? = false) {
    let mapController = DevicesMapViewController(delegate: nil)
    mapController.deviceName = deviceName ?? ""
    mapController.isDeviceIndoor = isIndoor ?? false
    self.slideMenuController()?.changeMainViewController(mapController, close: true)
    closePressed()
  }

  func transitionToDevice(name: String) {
    guard let device = DeviceStore.shared.getDevice(name: name) else { return }

    if let current = self.slideMenuController()?.mainViewController as? MainViewController {
      current.device = device
      closePressed()
      return
    }

    let mainViewController = MainViewController(delegate: nil)
    mainViewController.modalPresentationStyle = .fullScreen
    mainViewController.device = device
    mainViewController.isFromMapFlow = true
    

    self.slideMenuController()?.changeMainViewController(mainViewController, close: true)
  }

  func transitionToCity() {
    let device = AirDevice(deviceId: "", name: Constants.Readings.sarajevo,
                           active: true, model: Constants.Readings.sarajevo,
                           indoor: false, mine: false, defaultDevice: true,
                           location: nil, latest: nil, mapMeta: nil, timestamp: nil)

    if let current = self.slideMenuController()?.mainViewController as? MainViewController {
      current.device = device
      closePressed()
      return
    }

    let deviceViewController = MainViewController(delegate: nil)
    deviceViewController.modalPresentationStyle = .fullScreen
    deviceViewController.device = device

    self.slideMenuController()?.changeMainViewController(deviceViewController, close: true)
  }

  func refreshDevices() {
    showProgressHUD(with: "Pulling new device data...")
    DeviceStore.shared.removeDevices()
    CityOS.shared.initializeDevices { success in
      self.hideProgressHUD()
      if success {
        self.setupSections()
        self.tableView.reloadData()
      }
    }
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return indexPath.section == 0 ? 45 : 40
  }
}

// MARK: - Cache Usable
extension MenuViewController: CacheUsable {
  func didUpdateDeviceCache() {
    print("Delegate Called")
    setupSections()
    tableView.reloadData()
  }
}

// MARK: - Main Device Added Protocol
extension MenuViewController: MainDeviceAddedProtocol {
  func deviceAdded(with token: String) {
    showProgressHUD(with: "Pulling new device data...")
    DeviceStore.shared.removeDevices()
    CityOS.shared.initializeDevices { success in
      self.hideProgressHUD()
      if success {
        self.setupSections()
        self.tableView.reloadData()
        self.transitionToDevice(token: token)
      }
    }
  }
  
  func transitionToDevice(token: String) {
    guard let device = DeviceStore.shared.getDevice(deviceId: token) else { return }
    
    if let current = self.slideMenuController()?.mainViewController as? MainViewController {
      current.device = device
      closePressed()
      return
    }
    
    let deviceViewController = MainViewController(delegate: nil)
    deviceViewController.modalPresentationStyle = .fullScreen
    deviceViewController.device = device
    
    self.slideMenuController()?.changeMainViewController(deviceViewController, close: true)
  }
}

extension MenuViewController: LoginRouterDelegate {
  func loggedInFromSideMenu() {
    guard let device = DeviceStore.shared.getMyDevice() else { return }
    transitionToDevice(token: device.deviceId)
  }
}
