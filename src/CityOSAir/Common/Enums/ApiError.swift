//
//  ApiError.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 12/26/19.
//  Copyright © 2019 CityOS. All rights reserved.
//

import Foundation

struct ApiErrorResponse: Codable {
  let code: Int
  let errors: [Error]

  struct Error: Codable {
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

/// aimed to provide human readable errors. this is from api, to find time and implement class and add to network layet to provide user understandable errorr
enum ApiErrorCode: Int {
  case apiUnknownError = 1001 // "unknown error"
  case apiRegistrationMissingFirstName = 1002 // "registration error [missing user's first name]"
  case apiRegistrationMissingLastName = 1003 // "registration error [missing user's last name]"
  case apiRegistrationInvalidGender = 1004 // "registration error [invalid gender value]"
  case apiRegistrationMissingEmail = 1005 // "registration error [missing email]"
  case apiRegistrationMissingPass = 1006 // "registration error [missing password]"
  case apiRegistrationIncorrectRequest = 1007 // "registration error [could not read request]"
  case apiRegistrationCognitoSignupError = 1008 // "registration error [cannot register user. cognito signup error]"
  case apiRegistrationSignInError = 1009 // "signin error [cannot singin user. cognito signin error]"
  case apiMissingCognitoID = 1010 // "profile error [missing cognito ID]"
  case apiMissingThingModel = 1011 // "cannot add device. Missing model"
  case apiMissingThingName = 1012 // "cannot add device. Missing name"
  case apiMissingThingLocation = 1013 // "cannot add device. Missing location"
  case apiMissingThingToken = 1014 // "cannot get device details. Missing token"
  case apiMissingSensorType = 1015 // "cannot get map details. Missing sensor"
  case apiMissingBio = 1016 // "cannot update profile details. Missing bio"
  case apiMissingFirstname = 1017 // "cannot update profile details. Missing first name"
  case apiMissingLastname = 1018 // "cannot update profile details. Missing last name"
  case apiMissingMantra = 1019 // "cannot update profile details. Missing mantra"
  case apiMissingCity = 1020 // "cannot update profile details. Missing City"
  case apiMissingWebsite = 1021 // "cannot update profile details. Missing website"
  case apiMissingBirthday = 1022 // "cannot update profile details. Missing birthday"
  case apiNotYours = 1023 // "cannot retrieve device. It does not belong to you"
  case apiMissingRefreshToken = 1024 // "could not refresh identity tokens. Missing refresh token"
  case apiDeviceNotFound = 1025 // "could not find the desired device"
  case apiSchemaNotFound = 1026 // "could not find the desired schema"
  case apiIncorrectRequest = 1027 // "could not understand the request"
  case apiIncorrectTime = 1028 // "could not understand the time"
  case apiMissingChart = 1029 // "cannot get data count. Missing chart type"
  case apiMissingSocialData = 1030 // "Missing social data"
  case apiMissingCode = 1031 // "Missing code"
  case apiCouldNotInitiateForgottenPasswordFlow = 1032 // "Forgot password flow error"
  case apiCityMissingName = 1033 // "Cannot add city missing name"
  case apiCityMissingCountry = 1034 // "Cannot add city, missing country"
  case apiCityMissingZones = 1035 // "cannot add city, missing zones or invalid data"
  case apiMissingCityID = 1036 // "cannot complete action. Missing city id"
  case apiCityNotFound = 1037 // "could not find the desired city"
  case apiMissingID = 1038 // "cannot get device details. Missing identifier"
  case apiZoneNotFound = 1039 // "could not find the desired zone"
}
