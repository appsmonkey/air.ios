//
//  ConnectivityManager.swift
//  CityOSAir
//
//  Created by Haris Kovacevic on 13/05/2019.
//  Copyright © 2019 CityOS. All rights reserved.
//

import Foundation
import Reachability

class ConnectivityManager {
  static let shared: ConnectivityManager = ConnectivityManager()
  private let reachability: Reachability

  private init() {
    do {
      reachability = try Reachability()
      observeConnectionStatus();
    } catch {
      print("ConnectivityManager init error: \(error)")
      fatalError()
    }
  }

  func isConnected() -> Bool {
    return reachability.connection != .unavailable
  }

  func observeConnectionStatus() {
    reachability.whenUnreachable = { _ in NoInternetConnectionDialog.shared.show() }
    reachability.whenReachable = { _ in NoInternetConnectionDialog.shared.hide() }

    do {
      try reachability.startNotifier()
    } catch {
      print("Unable to start notifier")
    }
  }
}
