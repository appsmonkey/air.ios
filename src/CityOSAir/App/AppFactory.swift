//
//  AppFactory.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 1/8/20.
//  Copyright © 2020 CityOS. All rights reserved.
//

import UIKit

class AppFactory {
  static let shared = AppFactory()
  
  func getMainWindow(with window: UIWindow) {
    //Default opening screen for small delay form network request
    let splashViewController = SplashViewController()
    window.rootViewController = splashViewController
    
    // initialize devices
    CityOS.shared.initializeDevices { success in
      if success {
        log.info("Devices successfully initialized in App Delegate")
      } else {
        log.error("Failed to initialize devices in App Delegate")
      }
    }
    
    // if first launch save default devices and perform schema intialization
    if !UserDefaults.standard.isAppAlreadyLaunchedOnce()  {
      DeviceStore.shared.save(devices: AirDevice.defaultDevices)
      CityOS.shared.initializeSchema { success in
        if success {
          self.initializeSplashWindow(window: window)
        }
      }
    } else {
      // otherwise init realm
      RealmMigrationInitializer().initialize()
      
      // get schema from local storage
      let schema = ApplicationManager.shared.getSchema()
      // in case schema is nil, get schema again and init splash window since there was some app upgrade
      if schema == nil {
        CityOS.shared.initializeSchema { success in
          self.initializeSplashWindow(window: window)
        }
      } else {
        // otherwise init main window
        initializeMainWindow(window: window)
      }
    }
  }
  
  func initializeSplashWindow(window: UIWindow) {
    let navigationController = UINavigationController(rootViewController: WelcomeViewController())
    navigationController.modalPresentationStyle = .fullScreen
    navigationController.interactivePopGestureRecognizer?.isEnabled = false
    window.rootViewController = navigationController
  }
  
  func initializeMainWindow(window: UIWindow) {
    let deviceViewController = MainViewController(delegate: nil)
    
    // get first city if not get city air. this is not exactly necesary since
    // there's a new flow spec on main screen that solves this.
    // refactor out on migration to core data
    if let city = Cache.sharedCache.getCity() {
      UserManager.sharedInstance.currentCity = AirCity(rawValue: city.name) ?? AirCity.sarajevo
    } else {
      UserManager.sharedInstance.currentCity = AirCity.sarajevo
    }
    
    // if user is logged in go to device/city air dashboard
    if AirUserManager.shared.isLoggedIn() {
      let slideMenuViewController = SlideMenuController(mainViewController: deviceViewController,
                                                        leftMenuViewController: MenuViewController())
      slideMenuViewController.modalPresentationStyle = .fullScreen
      SlideMenuOptions.contentViewScale = 1
      SlideMenuOptions.hideStatusBar = false
      window.rootViewController = slideMenuViewController
    } else {
      // if not go to login screen
      let loginViewController = LoginViewController(delegate: nil)
      loginViewController.modalPresentationStyle = .fullScreen
      let navigationController = UINavigationController(rootViewController: loginViewController)
      navigationController.modalPresentationStyle = .fullScreen
      navigationController.interactivePopGestureRecognizer?.isEnabled = false
      window.rootViewController = navigationController
    }
  }
}
