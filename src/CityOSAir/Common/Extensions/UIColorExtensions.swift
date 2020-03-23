//
//  UIColorExtensions.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 11/28/19.
//  Copyright © 2019 CityOS. All rights reserved.
//

import UIKit

class Gradient {
  class func mainGradient() -> CAGradientLayer {

    let gradientLayer = CAGradientLayer()

    gradientLayer.colors = [
      Styles.Colors.gradientTop.cgColor,
      Styles.Colors.gradientBottom.cgColor
    ]

    return gradientLayer
  }
}

extension UIColor {
  static func fromHex(_ hex: String) -> UIColor {
    var cString: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()

    if cString.hasPrefix("#") {
      let start = cString.index(cString.startIndex, offsetBy: 1)
      cString = String(cString[start...])
    }

    if ((cString.count) != 6) {
      return UIColor.gray
    }

    var rgbValue: UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)

    return UIColor(
      red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
      green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
      blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
      alpha: CGFloat(1.0)
    )
  }
}
