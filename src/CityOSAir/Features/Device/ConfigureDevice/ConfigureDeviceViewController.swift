//
//  ConfigureDeviceViewController.swift
//  CityOSAir
//
//  Created by Haris Kovacevic on 01/07/2019.
//  Copyright © 2019 CityOS. All rights reserved.
//

import Foundation

import UIKit
import SnapKit
import WebKit

// MARK: - ConfigureDevice Display Protocols
protocol ConfigureDeviceDisplayLogic: class {
  
}

class ConfigureDeviceViewController: UIViewController {
  var devicePayload: AirDevicePayload!
  
  var interactor: ConfigureDeviceBusinessLogic?
  var router: ConfigureDeviceRoutingLogic?
  
  var mainDeviceAddedProtocol: MainDeviceAddedProtocol?
  
  lazy var configureDeviceContentView = ConfigureDeviceContentView.autolayoutView()
  
  init(delegate: ConfigureDeviceRouterDelegate?, mainDeviceAddedProtocol: MainDeviceAddedProtocol?) {
    super.init(nibName: nil, bundle: nil)
    let interactor = ConfigureDeviceInteractor()
    let presenter = ConfigureDevicePresenter()
    let router = ConfigureDeviceRouter()
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
    hideKeyboardWhenTappedAround()
    super.viewDidLoad()
    setupViews()

    let myURL = URL(string: Constants.Device.deviceUrl)
    let myRequest = URLRequest(url: myURL!)
    configureDeviceContentView.webView.load(myRequest)
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

extension ConfigureDeviceViewController: WKNavigationDelegate {

  func setupViews() {
    view.addSubview(configureDeviceContentView)
    
    configureDeviceContentView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    configureDeviceContentView.closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
    configureDeviceContentView.webView.navigationDelegate = self
  }

  @objc
  func close() {
    navigationController?.dismiss(animated: true, completion: nil)
  }

  @objc
  func openSettings() {
    router?.navigateToSettings()
  }

  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    if let currentUrl = webView.url?.absoluteString {
      if currentUrl.starts(with: Constants.Device.deviceSaveUrl) {
        router?.navigateToDeviceLocation(with: devicePayload, mainDeviceAddedProtocol: mainDeviceAddedProtocol)
      }
    }
  }
}

// MARK: - ConfigureDevice Display Protocols

extension ConfigureDeviceViewController: ConfigureDeviceDisplayLogic {
  
}
