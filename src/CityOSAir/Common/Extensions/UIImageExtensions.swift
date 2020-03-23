//
//  UIImageExtensions.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 11/28/19.
//  Copyright © 2019 CityOS. All rights reserved.
//

import UIKit

extension UIImageView {
  func setImageColor(color: UIColor) {
    let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
    self.image = templateImage
    self.tintColor = color
  }
}

extension UIImage {
  func resizeImage(targetSize: CGSize) -> UIImage {
    let size = self.size
    let widthRatio = targetSize.width / size.width
    let heightRatio = targetSize.height / size.height
    let newSize = widthRatio > heightRatio
      ? CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
      : CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
    let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
    self.draw(in: rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return newImage!
  }

  func filled(with color: UIColor) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(size, false, scale)
    color.setFill()
    guard let context = UIGraphicsGetCurrentContext() else { return self }
    context.translateBy(x: 0, y: size.height)
    context.scaleBy(x: 1.0, y: -1.0);
    context.setBlendMode(CGBlendMode.normal)
    let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
    guard let mask = self.cgImage else { return self }
    context.clip(to: rect, mask: mask)
    context.fill(rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return newImage
  }
}
