//
//  StatusCodes.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 12/5/19.
//  Copyright © 2019 CityOS. All rights reserved.
//

import Foundation

enum StatusCodes: Int {
  case ok = 200
  case created = 201
  case accepted = 202
  case baadRequest = 400
  case unauthorized = 401
  case forbidden = 403
  case notFound = 404
  case unprocessable = 422
}
