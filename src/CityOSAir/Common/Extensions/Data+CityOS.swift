//
//  Data+CityOS.swift
//  CityOSAir
//
//  Created by Haris Kovacevic on 20/11/2019.
//  Copyright © 2019 CityOS. All rights reserved.
//

import Foundation

extension Data {
  var prettyPrintedJSONString: NSString? {
    guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
      let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
      let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }

    return prettyPrintedString
  }
}
