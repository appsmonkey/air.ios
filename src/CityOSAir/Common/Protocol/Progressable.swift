//
//  ViewInterface.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 12/25/19.
//  Copyright © 2019 CityOS. All rights reserved.
//

import UIKit
import SVProgressHUD

protocol Progressable: class {
  func showProgressHUD()
  func hideProgressHUD()
  func showProgressHUD(with status: String)
}

extension Progressable {
  
  func showProgressHUD() {
    SVProgressHUD.show()
  }
  
  func showProgressHUD(with status: String) {
    SVProgressHUD.show(withStatus: status)
  }
  
  func hideProgressHUD() {
    SVProgressHUD.dismiss()
  }
}
