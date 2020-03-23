//
//  UpdateProfileRequest.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 12/4/19.
//  Copyright © 2019 CityOS. All rights reserved.
//

import Foundation

struct UpdateProfileRequest: Codable {
  var firstName: String
  var lastName: String
  var bio: String
  var city: String
  var gender: String
  var birthday: Int
}
