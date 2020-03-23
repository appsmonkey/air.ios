//
//  AirshipInitializer.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 12/1/19.
//  Copyright © 2019 CityOS. All rights reserved.
//

import Firebase
import GoogleSignIn

class EssentialsInitializer: Initializable {
  
  func initialize() {
    if Config.appConfiguration != .debug {
      Fabric.with([Crashlytics.self])
    }
    FirebaseApp.configure()
    GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID //Environment.googleSignInClientId
    
  }
  
}
