//
//  AppearanceInitializer.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 12/1/19.
//  Copyright © 2019 CityOS. All rights reserved.
//

import UIKit

class AppearanceInitializer: Initializable {
  
  func initialize() {
    UINavigationBar.appearance().isTranslucent = false
    UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: Styles.NavigationBar.tintColor,
                                                        NSAttributedString.Key.font: Styles.NavigationBar.font]
    UINavigationBar.appearance().barTintColor = UIColor(red:0.95, green:0.95, blue:0.95, alpha:1.00)
    
    //hide nav bar line
    UINavigationBar.appearance().setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    UINavigationBar.appearance().shadowImage = UIImage()
    
    //set nav back button
    let backArrowImage = UIImage(named: "backbtn")
    let renderedImage = backArrowImage?.withRenderingMode(.alwaysOriginal)
    UINavigationBar.appearance().backIndicatorImage = renderedImage
    UINavigationBar.appearance().backIndicatorTransitionMaskImage = renderedImage
  }
  
}
