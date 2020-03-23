//
//  UIFontExtensions.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 11/28/19.
//  Copyright © 2019 CityOS. All rights reserved.
//

import UIKit

extension UIFont {

  static var delta: CGFloat {
    return UIDevice.delta
  }

  static func appRegularWithSize(_ size: CGFloat) -> UIFont {
    return UIFont(name: Styles.FontFace.regular, size: size * delta)!
  }

  static func appMediumWithSize(_ size: CGFloat) -> UIFont {
    return UIFont(name: Styles.FontFace.medium, size: size * delta)!
  }

  static func appUltraThinWithSize(_ size: CGFloat) -> UIFont {
    return UIFont(name: Styles.FontFace.ultraLight, size: size * delta)!
  }

}
