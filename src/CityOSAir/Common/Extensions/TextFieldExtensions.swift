//
//  TextField.swift
//  CityOSAir
//
//  Created by Haris Kovacevic on 05/06/2019.
//  Copyright © 2019 CityOS. All rights reserved.
//

import UIKit


class UnderlineTextField: UITextField {
  override func layoutSubviews() {
    super.layoutSubviews()
    let bottomLine = CALayer()
    let size = CGFloat(0.5)
    bottomLine.frame = CGRect(x: 0.0, y: frame.height - size, width: frame.width, height: size)
    bottomLine.backgroundColor = UIColor.gray.cgColor
    borderStyle = UITextField.BorderStyle.none
    layer.addSublayer(bottomLine)
  }
}
