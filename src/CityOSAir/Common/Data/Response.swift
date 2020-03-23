//
//  Response.swift
//  CityOSAir
//
//  Created by Haris Kovacevic on 24/04/2019.
//  Copyright © 2019 CityOS. All rights reserved.
//

import Foundation

struct Response<T: Decodable> : Decodable {
  var code: Int
  var data: T?
  var errors: [ApiError]?
}
