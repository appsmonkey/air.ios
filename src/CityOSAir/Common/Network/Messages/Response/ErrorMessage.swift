//
//  ErrorMessage.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 12/26/19.
//  Copyright © 2019 CityOS. All rights reserved.
//

import Foundation

struct ErrorMessage {
  let code: Int
  let data: Bool?
  let requestId: String
  let errors: [Error]
  
  enum CodingKeys: String, CodingKey {
    case code
    case data
    case requestId = "request_id"
  }
  
  struct Error {
    let errorCode: Int
    let errorMessage: String
    let errorData: String
    
    enum CodingKeys: String, CodingKey {
      case errorCode = "error-code"
      case errorMessage = "error-message"
      case errorData = "error-data"
    }
  }
}
