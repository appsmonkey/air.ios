//
//  Reusable.swift
//  CityOSAir
//
//  Created by Andrej Saric on 28/08/16.
//  Copyright © 2016 CityOS. All rights reserved.
//

import UIKit

protocol Reusable: class {
  static var identifier: String { get }
}

extension Reusable where Self: UIView {
  static var identifier: String {
    return NSStringFromClass(self)
  }
}

