//
//  SVProgressHudInitializer.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 12/25/19.
//  Copyright © 2019 CityOS. All rights reserved.
//

import UIKit
import SVProgressHUD

class SVProgressHudInitializer: Initializable {
  
  func initialize() {
    SVProgressHUD.setForegroundColor(UIColor.white)
    SVProgressHUD.setDefaultStyle(.dark)
  }
  
}
