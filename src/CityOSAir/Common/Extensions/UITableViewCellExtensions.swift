//
//  UITableViewCellExtensions.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 11/28/19.
//  Copyright © 2019 CityOS. All rights reserved.
//

import UIKit

extension UITableViewCell {

  func addBorder() {
    let border = CALayer()
    let dotImage = UIImage(named: "dot")!.filled(with: Styles.FormCell.inputColor)
    border.backgroundColor = (UIColor(patternImage: dotImage)).cgColor
    border.frame = CGRect(x: 0, y: frame.size.height - 2, width: frame.size.width, height: 2)
    layer.addSublayer(border)
  }
}

