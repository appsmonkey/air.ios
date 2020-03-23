//
//  CodableExt.swift
//  CityOSAir
//
//  Created by Haris Kovacevic on 24/04/2019.
//  Copyright © 2019 CityOS. All rights reserved.
//

import Foundation

extension Encodable {
  func asDictionary() -> [String: String] {
    do {
      let data = try JSONEncoder().encode(self)
      guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: String] else {
        return [:]
      }
      return dictionary

    } catch {
      return [:]
    }
  }
}
