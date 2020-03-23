//
//  AppDelegate.swift
//  CityOSAir
//
//  Created by Andrej Saric on 25/08/16.
//  Copyright © 2016 CityOS. All rights reserved.
//

import UIKit
import Firebase
import FirebaseMessaging
import AirshipKit
import UserNotifications
import GoogleSignIn
import FBSDKCoreKit
import SwiftyBeaver

let log = SwiftyBeaver.self

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    // Initialize dependencies
    _initializeDependencies(LoggerInitializer(),
                            EssentialsInitializer(),
                            AppearanceInitializer(),
                            SessionInitializer(),
                            SVProgressHudInitializer())

    print("In \(Config.appConfiguration == .debug ? "Debug" : "Release") Mode")

    initFacebook(application, didFinishLaunchingWithOptions: launchOptions)

    let frame = UIScreen.main.bounds
    window = UIWindow(frame: frame)

    if let window = self.window {
      // set main window.
      AppFactory.shared.getMainWindow(with: window)
      window.makeKeyAndVisible()
    }
    
    // init urban airship
    UAirship.takeOff()
    UAirship.push()?.userPushNotificationsEnabled = true
    UAirship.push()?.pushNotificationDelegate = self
    UAirship.push()?.defaultPresentationOptions = [.alert, .badge, .sound]
    UAirship.debugDescription()

    return true
  }

  private func _initializeDependencies(_ dependencyInitializers: Initializable...) {
    for dependencyInitializer in dependencyInitializers {
      dependencyInitializer.initialize()
    }
  }
}

extension AppDelegate: UAPushNotificationDelegate {
  func receivedBackgroundNotification(_ notificationContent: UANotificationContent, completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    updateTags(notificationContent)
    completionHandler(UIBackgroundFetchResult.noData)
  }

  func receivedForegroundNotification(_ notificationContent: UANotificationContent, completionHandler: @escaping () -> Void) {
    updateTags(notificationContent)
    completionHandler()
  }

  private func updateTags(_ notification: UANotificationContent) {
    if let tags: [String] = notification.notificationInfo["^+t"] as? [String] {
      UAirship.push()?.updateTags(forLastReceivedTag: tags)
    }
  }
}

extension AppDelegate {

  func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
    if let scheme = url.scheme, scheme.localizedCaseInsensitiveCompare("io.cityos.air") == .orderedSame {

      var parameters: [String: String] = [:]
      URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems?.forEach {
        parameters[$0.name] = $0.value
      }

      switch(url.host) {
      case "register":
        guard let email = parameters["email"] else {
          return false
        }
        let controller = SignUpViewController(delegate: nil)
        controller.email = email
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.interactivePopGestureRecognizer?.isEnabled = false
        window?.rootViewController = navigationController
        return true
      default:
        return false
      }

    }

    let handled = ApplicationDelegate.shared.application(app, open: url, options: options)
    if (handled) {
      return true
    }

    guard let gidSharedInstance = GIDSignIn.sharedInstance() else { return false }
    return gidSharedInstance.handle(url)
  }

  func initFacebook(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
    ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

}

// MARK: - Univeral Links

extension AppDelegate {
  func application(_ application: UIApplication,
                   continue userActivity: NSUserActivity,
                   restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
    
    guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
      let url = userActivity.webpageURL,
      let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
        return false
    }
    
    guard let window = window else { return false }
    
    // deep links for registration and reset password handler
    return DeeplinkManager.sharedInstance.handleUniversalLink(with: url, components: components, window: window)
  }
}
