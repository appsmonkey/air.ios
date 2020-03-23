//
//  NetworkError.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 11/28/19.
//  Copyright © 2019 CityOS. All rights reserved.
//

import Alamofire

enum NetworkError: Error {
  case General(String)
  case ApiError(ApiErrorResponse)
  case Decoding(Error)
  case Alamofire(AFError)
  case Login(Error)
  case NoConnection(String)
  
  var message: String {
    switch self {
    case .General(let message):
      return message
    case .Decoding(let error):
      return "Decoding error: \(error.localizedDescription)"
    case .ApiError(let error):
      return "Api Error: \(error)"
    case .Alamofire(let error):
      return "Alamofire error: \(error.localizedDescription)"
    case .Login(let error):
      return "Login error: \(error.localizedDescription)"
    case .NoConnection:
      return "No internet connection"
    }
  }
}
