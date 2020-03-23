//
//  Router.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 11/28/19.
//  Copyright © 2019 CityOS. All rights reserved.
//

import Alamofire

enum Router: URLRequestConvertible {
  // TODO: Implement environment sensitive builds and configurations
//  fileprivate static let _baseURL = URL(string: "https://apigway.cityos.io")!
   fileprivate static let _baseURL = URL(string: "https://api.cityos.io")!

  case login(credentials: Credentials)
  case profile
  case refreshToken(auth: AuthRequest)
  case schema
  case device(token: String)
  case chartReadings(period: ReadingPeriod, type: ReadingGroup, token: String?, sensor: String)
  case map(sensor: String, data: String, type: String)
  case updateProfile(request: UpdateProfileRequest)
  case validate(request: VerifyEmailRequest)
  case signUp(request: SignUpRequest)
  case checkAccountStatus(credentials: Credentials)
  case forgotPasswordStart(request: ForgotPasswordStartRequest)
  case forgotPasswordEnd(request: ForgotPasswordEndRequest)
  case deviceToken
  case addDevice(request: AddDeviceRequest)
  case register(request: CreateUserRequest)
  case devices

  fileprivate var method: HTTPMethod {
    switch self {
    case .updateProfile:
      return .put
    case .login, .refreshToken, .register, .checkAccountStatus, .forgotPasswordStart, .forgotPasswordEnd, .addDevice, .signUp:
      return .post
    default:
      return .get
    }
  }

  fileprivate var path: String {
    switch self {
    case .login:
      return "/auth/login"
    case .profile:
      return "/profile"
    case .refreshToken:
      return "/auth/refresh"
    case .devices:
      return "/device/list"
    case .schema:
      return "/schema"
    case .device(_):
      return "/device/get"
    case .chartReadings(let period, let type, _, _):
      return "/chart/\(period.identifier())/\(type.rawValue)"
    case .map(_, _, _):
      return "/map"
    case .register:
      return "/auth/register"
    case .validate:
      return "/auth/validate"
    case .updateProfile:
      return "/profile"
    case .signUp:
      return "/auth/profile"
    case .checkAccountStatus:
      return "/auth/validate/email"
    case .forgotPasswordStart:
      return "/auth/password/start"
    case .forgotPasswordEnd:
      return "/auth/password/end"
    case .deviceToken:
      return "http://192.168.4.1/id"
    case .addDevice:
      return "/device/add"
    }
  }

  func asURLRequest() throws -> URLRequest {
    let url = Router._baseURL

    var urlRequest: URLRequest!

    urlRequest = URLRequest(url: url.appendingPathComponent(path))
    urlRequest.httpMethod = method.rawValue

    urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
    urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")

    // Parameters

    switch self {
    case let .login(credentials):
      do {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        let jsonBody = try JSONEncoder().encode(credentials)
        urlRequest.httpBody = jsonBody
      } catch {
        log.info(error)
      }
      break
    case let .checkAccountStatus(request):
      log.info("/auth/validate/email with: \(request)")
      do {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        let jsonBody = try JSONEncoder().encode(request)
        urlRequest.httpBody = jsonBody
      } catch {
        log.info(error)
      }
      break
    case let .register(request):
      log.info("/register")
      do {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        let jsonBody = try JSONEncoder().encode(request)
        urlRequest.httpBody = jsonBody
      } catch {
        log.info(error)
      }
      break
    case let .validate(request):
      urlRequest.url = urlRequest.url?.appending("client_id", value: request.clientId)
      urlRequest.url = urlRequest.url?.appending("user_name", value: request.userName)
      urlRequest.url = urlRequest.url?.appending("confirmation_code", value: request.confirmationCode)
      urlRequest.url = urlRequest.url?.appending("type", value: request.type)
      urlRequest.url = urlRequest.url?.appending("cog_id", value: request.cogId)
      break
    case let .updateProfile(request):
      log.info("/profile")
      do {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        let jsonBody = try JSONEncoder().encode(request)
        urlRequest.httpBody = jsonBody
      } catch {
        log.info(error)
      }
      break
    case let .signUp(request):
      log.info("/auth/profile")
      do {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        let jsonBody = try JSONEncoder().encode(request)
        urlRequest.httpBody = jsonBody
      } catch {
        log.info(error)
      }
      break
    case let .forgotPasswordStart(request):
      log.info("/auth/password/start \(request)")
      do {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        let jsonBody = try JSONEncoder().encode(request)
        urlRequest.httpBody = jsonBody
      } catch {
        log.info(error)
      }
      break
    case let .forgotPasswordEnd(request):
      log.info("/auth/password/end \(request)")
      do {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        let jsonBody = try JSONEncoder().encode(request)
        urlRequest.httpBody = jsonBody
      } catch {
        log.info(error)
      }
      break
    case let .map(sensor, data, type):
      urlRequest.url = urlRequest.url?.appending("zone_data", value: sensor)
      urlRequest.url = urlRequest.url?.appending("device_data", value: data)
      urlRequest.url = urlRequest.url?.appending("filter", value: type)
      log.info("MAP with URL: \(String(describing: urlRequest.url))")
      break
    case let .device(token):
      log.info("/device/get with token: \(token)")
      if !token.isEmpty {
        urlRequest.url = urlRequest.url?.appending("token", value: token)
      }
      break
    case .devices:
      log.info("/device/list")
      break
    case let .addDevice(request):
      log.info("/device/add with request \(request)")
      do {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        let jsonBody = try JSONEncoder().encode(request)
        urlRequest.httpBody = jsonBody
      } catch {
        log.info(error)
      }
      break
    case .schema:
      log.info("/schema")
      urlRequest.addValue("1", forHTTPHeaderField: "Accept-Version")
      break
    case .chartReadings(let period, let type, let token, let sensor):
      if type == .device {
        urlRequest.url = urlRequest.url?.appending("token", value: token)
        urlRequest.url = urlRequest.url?.appending("from", value: "\(period.duration())")
        urlRequest.url = urlRequest.url?.appending("sensor", value: sensor)
      } else {
        urlRequest.url = urlRequest.url?.appending("from", value: "\(period.duration())")
        urlRequest.url = urlRequest.url?.appending("sensor", value: sensor)
      }
      break
    case let .refreshToken(request):
      log.info("/auth/refresh with request: \(request)")
      do {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        let jsonBody = try JSONEncoder().encode(request)
        urlRequest.httpBody = jsonBody
      } catch {
        log.info(error)
      }
      break
    case .deviceToken:
      log.info("http://192.168.4.1/id")
      urlRequest.url = URL(string: "http://192.168.4.1/id")
      break
    default:
      print("implementing")
    }

    return urlRequest
  }

}
