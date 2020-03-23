//
//  Button.swift
//  CityOSAir
//
//  Created by Haris Kovacevic on 05/06/2019.
//  Copyright © 2019 CityOS. All rights reserved.
//

import UIKit

public enum AppButtonType {
  case normal
  case secondary
  case transparent
  case label
}

extension UIButton {
  
  func setType(type:AppButtonType) {
    switch type {
    case .normal:
      backgroundColor = Styles.BigButton.backgroundColor
      tintColor = Styles.BigButton.tintColor
      titleLabel?.font = Styles.BigButton.font
    case .secondary:
      backgroundColor = Styles.BigButtonSecondary.backgroundColor
      tintColor = Styles.BigButtonSecondary.tintColor
      titleLabel?.font = Styles.BigButtonSecondary.font
    case .transparent:
      layer.borderWidth = 0.5
      titleLabel?.font = Styles.BigButton.font
      setTitleColor(UIColor.gray, for: UIControl.State())
      layer.borderColor = UIColor.gray.cgColor
    case .label:
      setTitleColor(Styles.SmallButton.tintColor, for: UIControl.State())
      titleLabel?.font = Styles.SmallButton.font
    }
    layer.cornerRadius = 5
  }
  
  override open var isEnabled: Bool {
    didSet {
      backgroundColor = isEnabled ? backgroundColor?.withAlphaComponent(1.0) : backgroundColor?.withAlphaComponent(0.3)
    }
  }
  
  func setTitle(title:String){
    setTitle(title, for: UIControl.State())
  }
}

