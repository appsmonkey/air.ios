//
//  IconButton.swift
//  CityOSAir
//
//  Created by Haris Kovacevic on 05/06/2019.
//  Copyright © 2019 CityOS. All rights reserved.
//

import UIKit

class IconButton: UIButton {
  override func layoutSubviews() {
    super.layoutSubviews()
    if imageView != nil {
      imageEdgeInsets = UIEdgeInsets(top: 5, left: 8.0, bottom: 5, right: (bounds.width - 50))
      titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: (imageView?.frame.width)!)
    }
  }
}
