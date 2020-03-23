//
//  UIViewExtensions.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 11/28/19.
//  Copyright © 2019 CityOS. All rights reserved.
//

import UIKit

// MARK: - AutoLayout
public extension UIView {
  func autolayoutView() -> Self {
    translatesAutoresizingMaskIntoConstraints = false
    return self
  }

  class func autolayoutView() -> Self {
    let instance = self.init()
    instance.translatesAutoresizingMaskIntoConstraints = false
    return instance
  }
}

extension UIView {

  func addConstraintsWithFormat(_ format: String, metrics: [String: Any]? = nil, views: UIView...) {
    var viewsDictionary = [String: UIView]()
    for (index, view) in views.enumerated() {
      let key = "v\(index)"
      view.translatesAutoresizingMaskIntoConstraints = false
      viewsDictionary[key] = view
    }

    addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: metrics, views: viewsDictionary))
  }

  func addGradientAsBackground() {
    let gradient = Gradient.mainGradient()
    gradient.frame = self.bounds
    self.layer.insertSublayer(gradient, at: 0)
  }

  func roundCorners(corners: UIRectCorner, radius: CGFloat) {
    let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
    let mask = CAShapeLayer()
    mask.path = path.cgPath
    self.layer.mask = mask
  }
}
