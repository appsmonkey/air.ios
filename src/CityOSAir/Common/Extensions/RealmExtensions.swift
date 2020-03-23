//
//  RealmExtensions.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 11/28/19.
//  Copyright © 2019 CityOS. All rights reserved.
//

import RealmSwift

extension Results {

  func toArray() -> [Element] {
    return self.map { $0 }
  }
}

extension RealmSwift.List {

  func toArray() -> [Element] {
    return self.map { $0 }
  }
}
