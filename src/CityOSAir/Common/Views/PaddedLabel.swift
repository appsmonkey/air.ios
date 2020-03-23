//
//  PaddedLabel.swift
//  CityOSAir
//
//  Created by Andrej Saric on 24/01/2017.
//  Copyright © 2017 CityOS. All rights reserved.
//

import UIKit

class PaddedLabel: UILabel {

  let inset: CGFloat = 15.0

  override var intrinsicContentSize: CGSize {
    let contentSize = super.intrinsicContentSize
    return CGSize(width: contentSize.width + inset * 2, height: contentSize.height + inset)
  }
}
