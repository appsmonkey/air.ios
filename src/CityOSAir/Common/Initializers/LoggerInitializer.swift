//
//  LoggerInitializer.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 11/28/19.
//  Copyright © 2019 CityOS. All rights reserved.
//

import SwiftyBeaver

final class LoggerInitializer: Initializable {
  
  func initialize() {
    let console = ConsoleDestination()
    log.addDestination(console)
  }
  
}
