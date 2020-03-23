//
//  MapKitReusable.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 12/29/19.
//  Copyright © 2019 CityOS. All rights reserved.
//

import Foundation

public protocol MapKitReusable: class {

  static var reuseIdentifier: String { get }
}

public extension MapKitReusable {

  static var reuseIdentifier: String {
    return NSStringFromClass(self)
  }
}
