//
//  Dialogs.swift
//  CityOSAir
//
//  Created by Haris Kovacevic on 13/05/2019.
//  Copyright © 2019 CityOS. All rights reserved.
//

import Foundation
import UIKit

protocol Dialog {
  func show()
  func hide()
}

public class AlertDialog: Dialog {
  let alert: UIAlertController;

  init(title: String, message: String) {
    alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
  }

  func show() {
    DispatchQueue.main.async {
      self.alert.show()
    }
  }

  func hide() {
    DispatchQueue.main.async {
      self.alert.hide()
    }
  }

}

public class NoInternetConnectionDialog: Dialog {

  static let shared = NoInternetConnectionDialog();
  private let dialog: AlertDialog;
  private var showing: Bool = false;

  private init() {
    dialog = AlertDialog(title: "No internet connection", message: "Please make sure that You are connected to the internet.");

    dialog.alert.addAction(UIAlertAction(title: "Close", style: .default, handler: { action in
      self.hide();
    }))
  }

  func show() {
    if(!showing) {
      showing = true;
      dialog.show();
    }
  }

  func hide() {
    if(showing) {
      showing = false;
      dialog.hide();
    }
  }


}
