//
//  DeviceInfoViewController.swift
//  CityOSAir
//
//  Created by Haris Kovacevic on 02/07/2019.
//  Copyright © 2019 CityOS. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire

// MARK: - ConfigureDevice Display Protocols
protocol DeviceDetailsDisplayLogic: class {
  func displayMainSceren(with token: String)
  func displayError(_ error: NetworkError)
}

class DeviceDetailsViewController: UIViewController, Progressable {
  let form: [DeviceDetailsFormField] = [.name, .indoor]
  var devicePayload: AirDevicePayload!
  
  var interactor: DeviceDetailsBusinessLogic?
  var router: DeviceDetailsRoutingLogic?
  
  var mainDeviceAddedProtocol: MainDeviceAddedProtocol?
  
  lazy var deviceDetailsContentView = DeviceDetailsContentView.autolayoutView()
  private var refreshControl: UIRefreshControl!
  
  
  init(delegate: DeviceDetailsRouterDelegate?, mainDeviceAddedProtocol: MainDeviceAddedProtocol?) {
    super.init(nibName: nil, bundle: nil)
    let interactor = DeviceDetailsInteractor()
    let presenter = DeviceDetailsPresenter()
    let router = DeviceDetailsRouter()
    interactor.presenter = presenter
    presenter.viewController = self
    router.viewController = self
    router.delegate = delegate
    self.interactor = interactor
    self.router = router
    self.mainDeviceAddedProtocol = mainDeviceAddedProtocol
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    hideKeyboardWhenTappedAround()
    setupViews()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: false)

  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.navigationController?.setNavigationBarHidden(false, animated: false)
  }
}

extension DeviceDetailsViewController {

  func setupViews() {
    view.addSubview(deviceDetailsContentView)
    
    deviceDetailsContentView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    deviceDetailsContentView.tableView.dataSource = self
    deviceDetailsContentView.tableView.delegate = self
    
    deviceDetailsContentView.closeButton.addTarget(self, action: #selector(DeviceDetailsViewController.close), for: .touchUpInside)
    deviceDetailsContentView.doneButton.addTarget(self, action: #selector(DeviceDetailsViewController.addDeviceTapped), for: .touchUpInside)
  }

  @objc
  func close() {
    navigationController?.dismiss(animated: true, completion: nil)
  }

  @objc
  func addDeviceTapped() {
    showProgressHUD()
    let coordinates = AddDeviceRequest.Coordinates(lng: devicePayload.coordinates.lng, lat: devicePayload.coordinates.lat)
    let request = AddDeviceRequest(token: devicePayload.token,
                                   name: devicePayload.name,
                                   city: Constants.Cities.sarajevo,
                                   model: devicePayload.model,
                                   indoor: devicePayload.indoor,
                                   coordinates: coordinates)
    interactor?.addDevice(request: request)
  }

  @objc
  func textFieldDidChange(_ sender: UITextField) {
    devicePayload.name = sender.text ?? "Boxy"
  }

  @objc
  func switchToggled(_ sender: UISwitch) {
    devicePayload.indoor = sender.isOn
  }

}

extension DeviceDetailsViewController: UITableViewDataSource, UITableViewDelegate {

  func numberOfSections(in tableView: UITableView) -> Int {
    return form.count
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return form[section].spacing()
  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = UIView()
    headerView.backgroundColor = UIColor.clear
    return headerView
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return form[(indexPath as NSIndexPath).section].height()
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let fieldType: DeviceDetailsFormField = form[(indexPath as NSIndexPath).section]

    switch fieldType {
    case .name:
      let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as InputTableViewCell
      return cell.configure(
        placeholder: "Device Name",
        tag: fieldType.rawValue,
        target: self,
        action: #selector(DeviceDetailsViewController.textFieldDidChange(_:)),
        isSecure: false
      )

    case .indoor:
      let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as SwitchTableViewCell
      cell.switchControl.addTarget(self, action: #selector(DeviceDetailsViewController.switchToggled(_:)), for: .valueChanged)
      return cell.configure(
        label: "Indoor",
        isOn: false,
        isDisabled: false
      )

    }
  }

}

enum DeviceDetailsFormField: Int {
  case name
  case indoor
  //case submit

  func height() -> CGFloat {
    let delta = UIDevice.delta

    switch self {
    case .indoor:
      return 60
    default:
      return 30 * delta
    }
  }

  func spacing() -> CGFloat {
    switch self {
    case .indoor:
      return 20.0
    default:
      return 0.0
    }
  }
}

extension DeviceDetailsViewController: DeviceDetailsDisplayLogic {
  func displayMainSceren(with token: String) {
    hideProgressHUD()
    close()
    mainDeviceAddedProtocol?.deviceAdded(with: token)
  }
  
  func displayError(_ error: NetworkError) {
    hideProgressHUD()
    router?.navigateToAlert(title: "Error", message: error.message, handler: nil)
  }
}
