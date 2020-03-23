//
//  AddDeviceController.swift
//  CityOSAir
//
//  Created by Haris Kovacevic on 01/07/2019.
//  Copyright © 2019 CityOS. All rights reserved.
//

import UIKit
import SnapKit

// MARK: - Display Protocols
protocol ConnectDeviceDisplayLogic: class {
  func displayError(_ error: Error)
  func displayDevice(token: String)
}

class ConnectDeviceViewController: UIViewController, Progressable {
  var interactor: ConnectDeviceInteractor?
  var router: ConnectDeviceRouter?
  
  var mainDeviceAddedProtocol: MainDeviceAddedProtocol?
  
  lazy var connectDeviceContentView = ConnectDeviceContentView.autolayoutView()
  
  // MARK: - View Cycle
  init(delegate: ConnectDeviceRouterDelegate?, mainDeviceAddedProtocol: MainDeviceAddedProtocol?) {
    super.init(nibName: nil, bundle: nil)
    let interactor = ConnectDeviceInteractor()
    let presenter = ConnectDevicePresenter()
    let router = ConnectDeviceRouter()
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
    setupViews()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(true, animated: false)
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.navigationController?.setNavigationBarHidden(false, animated: false)
  }
}

// MARK: - Setup Views
extension ConnectDeviceViewController {

  func setupViews() {
    view.addSubview(connectDeviceContentView)
    
    connectDeviceContentView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    connectDeviceContentView.closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
    connectDeviceContentView.settingsButton.addTarget(self, action: #selector(openSettings), for: .touchUpInside)
    connectDeviceContentView.configureButton.addTarget(self, action: #selector(configure), for: .touchUpInside)
  }

  @objc
  func close() {
    navigationController?.dismiss(animated: true, completion: nil)
  }

  @objc
  func openSettings() {
    router?.navigateToSettings()
  }

  @objc
  func configure() {
    showProgressHUD()
    interactor?.getDeviceToken()
  }
}

// MARK: - Display Logic Implementation
extension ConnectDeviceViewController: ConnectDeviceDisplayLogic {
  func displayError(_ error: Error) {
    log.error(error)
    hideProgressHUD()
    router?.navigateToAlert(title: "Error", message: "Error while connecting to the device. Please ensure that you are connected to a Boxy!", handler: nil)
  }
  
  func displayDevice(token: String) {
    hideProgressHUD()
    router?.navigateToConfigureDeviceScreen(token: token, mainDeviceAddedProtocol: mainDeviceAddedProtocol)
  }
}
