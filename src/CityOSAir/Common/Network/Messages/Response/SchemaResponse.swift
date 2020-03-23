//
//  SchemaResponse.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 12/17/19.
//  Copyright © 2019 CityOS. All rights reserved.
//

import Foundation

struct SchemaResponse: Codable {
  let requestId: String
  let code: Int
  let errors: String?
  let data: [String: MapSchema]
  
  struct MapSchema: Codable {
    let name: String
    let unit: String
    let defaultValue: String
    let parseCondition: String = ""
    let steps: [Step]?
    
    private enum CodingKeys: String, CodingKey {
      case name
      case unit
      case steps
      case defaultValue = "default"
      case parseCondition = "parse_condition"
    }
    
    struct Step: Codable {
      let from: Double
      let to: Double
      let result: String
    }
  }
}
