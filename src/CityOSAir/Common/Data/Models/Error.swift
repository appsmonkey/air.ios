//
//  Error.swift
//  CityOSAir
//
//  Created by Haris Kovacevic on 24/04/2019.
//  Copyright © 2019 CityOS. All rights reserved.
//

import Foundation

struct ApiError: Decodable {
  var errorCode: Int
  var errorMessage: String
  var errorData: String

  enum CodingKeys: String, CodingKey {
    case errorCode = "error-code"
    case errorMessage = "error-message"
    case errorData = "error-data"
  }

  func getErrorMessage() -> String {
    let errorType = errorData.split(separator: ":", maxSplits: 1, omittingEmptySubsequences: true).first
    switch errorType {
    case "UserNotFoundException":
      return "User does not exist";
    case "NotAuthorizedException":
      return "Incorrect username or password";
    default:
      return "Something wrong happend";
    }
  }
}
