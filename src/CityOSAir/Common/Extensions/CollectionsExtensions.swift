//
//  CollectionsExtensions.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 11/28/19.
//  Copyright © 2019 CityOS. All rights reserved.
//

import Foundation

extension Collection { //where Indices.Iterator.Element == Index

  subscript (safe index: Index) -> Iterator.Element? {
    return indices.contains(index) ? self[index] : nil
  }
}

extension NSDictionary {
  var swiftDictionary: [String: Any] {
    var swiftDictionary = [String: Any]()

    for key: Any in self.allKeys {
      let stringKey = key as! String
      if let keyValue = self.value(forKey: stringKey) {
        swiftDictionary[stringKey] = keyValue
      }
    }

    return swiftDictionary
  }
}

extension Dictionary {
  init(_ pairs: [Element]) {
    self.init()
    for (k, v) in pairs {
      self[k] = v
    }
  }

  func mapPairs<OutKey: Hashable, OutValue>(transform: (Element) throws -> (OutKey, OutValue)) rethrows -> [OutKey: OutValue] {
    return Dictionary<OutKey, OutValue>(try map(transform))
  }

}
