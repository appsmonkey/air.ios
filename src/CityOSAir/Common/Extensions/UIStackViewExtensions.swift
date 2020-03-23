//
//  UIStackViewExtensions.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 1/10/20.
//  Copyright © 2020 CityOS. All rights reserved.
//

import UIKit

extension UIStackView {
  func removeAllArrangedSubviews() {
    let removedSubviews = arrangedSubviews.reduce([]) { (allSubviews, subview) -> [UIView] in
      self.removeArrangedSubview(subview)
      return allSubviews + [subview]
    }
    NSLayoutConstraint.deactivate(removedSubviews.flatMap({ $0.constraints }))
    removedSubviews.forEach({ $0.removeFromSuperview() })
  }
}
