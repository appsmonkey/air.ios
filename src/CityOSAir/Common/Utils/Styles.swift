//
//  Styles.swift
//  CityOSAir
//
//  Created by Andrej Saric on 28/08/16.
//  Copyright © 2016 CityOS. All rights reserved.
//

import UIKit

struct Styles {

  struct FontFace {
    fileprivate static let baseFont = "AvenirNext-"
    static let ultraLight = "\(baseFont)UltraLight"
    static let regular = "\(baseFont)Regular"
    static let medium = "\(baseFont)Medium"
  }

  struct Intro {

    struct HeaderText {
      static let font = UIFont.appRegularWithSize(15)
      static let tintColor = UIColor.fromHex("666666")
    }

    struct SubtitleText {
      static let font = UIFont.appRegularWithSize(10.5)
      static let tintColor = UIColor.fromHex("9e9e9e")
      static let lineSpacing = 14.0
    }

  }

  struct MapPopup {

    struct NameLabel {
      static let font = UIFont.appRegularWithSize(10)
      static let tintColor = UIColor.fromHex("4d4d4d")
    }

    struct MessageLabel {
      static let font = UIFont.appRegularWithSize(7)
    }

    struct IdentifierLabel {
      static let font = UIFont.appRegularWithSize(7)
      static let subscriptFont = UIFont.appRegularWithSize(7 / 2)
      static let tintColor = UIColor.fromHex("999999")
    }

    struct NumberLabel {
      static let font = UIFont.appRegularWithSize(9.5)
    }

    struct NotationLabel {
      static let font = UIFont.appRegularWithSize(5.6)
      static let tintColor = UIColor.fromHex("b2b2b2")
    }
  }

  struct Detail {

    struct HeaderText {
      static let font = UIFont.appRegularWithSize(16.5)
      static let subscriptFont = UIFont.appRegularWithSize(16.5 / 2)
      static let tintColor = UIColor.gray
    }

    struct SubtitleText {
      static let font = UIFont.appRegularWithSize(7.5)
      static let subscriptFont = UIFont.appRegularWithSize(7.5 / 2)
      static let tintColor = UIColor.lightGray
    }

  }

  struct DetailStates {
    static let greatColor = UIColor.fromHex("75e2ea")
    static let okColor = UIColor.fromHex("a1d78b")
    static let sensitiveColor = UIColor.fromHex("f8e88b")
    static let unhealthyColor = UIColor.fromHex("f8ab73")
    static let veryUnhealthyColor = UIColor.fromHex("d174c5")
    static let hazardousColor = UIColor.fromHex("f95356")
  }

  struct LabelStates {
    static let greatColor = UIColor.fromHex("02b8bc")
    static let okColor = UIColor.fromHex("68a82a")
    static let sensitiveColor = UIColor.fromHex("eabc28")
    static let unhealthyColor = UIColor.fromHex("ff8931")
    static let veryUnhealthyColor = UIColor.fromHex("d816bd")
    static let hazardousColor = UIColor.fromHex("f6263d")
  }

  struct Graph {

    struct HeaderText {
      static let font = UIFont.appRegularWithSize(16.5)
      static let subscriptFont = UIFont.appRegularWithSize(16.5 / 2)
      static let tintColor = UIColor.fromHex("4d4d4d")
    }

    struct StateLabel {
      static let font = UIFont.appRegularWithSize(8)
    }

    struct ReadingLabel {
      static let font = UIFont.appUltraThinWithSize(51)
      static let subscriptFont = UIFont.appRegularWithSize(51 / 5)
      static let subscriptColor = UIColor.fromHex("b2b2b2")
      static let tintColor = UIColor.fromHex("4d4d4d")
    }

    struct GraphLabels {
      static let font = UIFont.appRegularWithSize(5.88)//UIFont.appRegularWithSize(6.88)
      static let tintColor = UIColor.fromHex("cccccc")
      static let lineColor = UIColor.fromHex("efefef")
      static let textColor = UIColor.fromHex("9e9e9e")
    }
  }

  struct NavigationBar {
    static let font = UIFont.appMediumWithSize(11)
    static let tintColor = UIColor.fromHex("4a4a4a")
  }

  struct MenuButtonBig {
    static let font = UIFont.appRegularWithSize(12)
    static let tintColor = UIColor.fromHex("ffffff")
    static let choosenTintColor = UIColor.fromHex("2eeaff")
  }

  struct MenuButtonSmall {
    static let font = UIFont.appRegularWithSize(10)
    static let subscriptFont = UIFont.appRegularWithSize(10 / 2)
    static let tintColor = UIColor.fromHex("c9c9c9")
  }

  struct BigButton {
    static let font = UIFont.appRegularWithSize(10.0)
    static let tintColor = Colors.white
    static let backgroundColor = UIColor.fromHex("45cfdc")
  }

  struct BigButtonSecondary {
    static let font = UIFont.appRegularWithSize(10.0)
    static let tintColor = Colors.white
    static let backgroundColor = UIColor.lightGray
  }

  struct SmallButton {
    static let font = UIFont.appRegularWithSize(10)
    static let tintColor = UIColor.fromHex("43c5db")
  }

  struct FormCell {
    static let font = UIFont.appMediumWithSize(10)
    static let placeholderColor = UIColor.fromHex("c8c7cc")
    static let inputColor = UIColor.fromHex("525252")
  }

  struct DataCell {

    struct IdentifierLabel {
      static let font = UIFont.appRegularWithSize(10)
      static let subscriptFont = UIFont.appRegularWithSize(10 / 2)
      static let tintColor = UIColor.fromHex("4d4d4d")
    }

    struct ReadingLabel {
      static let numberFont = UIFont.appRegularWithSize(11.7)
      static let tintColor = UIColor.fromHex("b0b0b0")
    }

    struct NotationLabel {
      static let identifierFont = UIFont.appRegularWithSize(6.5)
      static let tintColor = UIColor.fromHex("b0b0b0")
    }

    struct FlagLabel {
      static let font = UIFont.appRegularWithSize(8)
    }

  }

  struct SettingsCell {
    static let titleFont = UIFont.appRegularWithSize(10)
    static let titleColor = UIColor.fromHex("525252")
    static let subtitleFont = UIFont.appRegularWithSize(7)
    static let subtitleColor = UIColor.fromHex("a6a6a6")
    static let rightDetailFont = UIFont.appRegularWithSize(10)
    static let rightDetailColor = UIColor.fromHex("43c5db")
  }

  struct Loading {
    static let font = UIFont.appRegularWithSize(12.5)
    static let tintColor = UIColor.fromHex("caebed")
  }

  struct Colors {
    static let white = UIColor.white
    static let gradientTop = UIColor.fromHex("15b2ba")
    static let gradientBottom = UIColor.fromHex("39b2cf")
  }

  struct GraphColors {

    static let defaultGradientColors = [
      UIColor.fromHex("01bcf3").cgColor,
      UIColor.fromHex("01ead4").cgColor
    ]

    static let defaultGradientLocations: [CGFloat] = [1.0, 0.0]

    static let pmGradientColors = [
      UIColor.fromHex("e80009").cgColor,
      UIColor.fromHex("d524a8").cgColor,
      UIColor.fromHex("ff7930").cgColor,
      UIColor.fromHex("ffe934").cgColor,
      UIColor.fromHex("73c84e").cgColor,
      UIColor.fromHex("03d2e2").cgColor
    ]
    
    static let pmGreatGradientColors = [
      UIColor.fromHex("03d2e2").cgColor,
      UIColor.fromHex("03d2e2").cgColor
    ]

    static let pmGradientLocations: [CGFloat] = [1.0,
      0.8,
      0.6,
      0.4,
      0.2,
      0.0]
  }

  static func cellHeight(_ cellType: CellType) -> CGFloat {

    let delta = UIDevice.delta

    switch cellType {
    case .bigBtn, .bigBtnSecondary:
//            let size = 50 * delta
      return 100//size < 80 ? 80 : size//100
    case .password, .email, .confirmPassword, .wiFiName, .wiFiPassword, .socialLogin:
      return 30 * delta//60
    case .smallBtn:
      return 25 * delta//50
//        default:
//            return 100 * delta
    }
  }
}
