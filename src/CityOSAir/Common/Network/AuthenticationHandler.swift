//
//  AuthenticationHandler.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 12/23/19.
//  Copyright © 2019 CityOS. All rights reserved.
//

import Alamofire

class AuthenticationHandler: RequestAdapter, RequestRetrier {
  private typealias RefreshCompletion = (_ succeeded: Bool, _ response: RefreshTokenResponse?) -> Void

  private let sessionManager: SessionManager = {
    let configuration = URLSessionConfiguration.default
    configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders

    return SessionManager(configuration: configuration)
  }()

  private let lock = NSLock()

  private var isRefreshing = false
  private var requestsToRetry: [RequestRetryCompletion] = []

  // MARK: - RequestAdapter

  func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
    if let urlString = urlRequest.url?.absoluteString, !urlString.hasSuffix("/auth/refresh") {
      var urlRequest = urlRequest
      urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
      if let idToken = CitySessionManager.shared.idToken, let accessToken = CitySessionManager.shared.accessToken {
        urlRequest.addValue(idToken, forHTTPHeaderField: "Authorization")
        urlRequest.addValue(accessToken, forHTTPHeaderField: "AccessToken")
      }
      return urlRequest
    }

    return urlRequest
  }

  // MARK: - RequestRetrier

  func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
    lock.lock() ; defer { lock.unlock() }

    if let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 {
      requestsToRetry.append(completion)

      if !isRefreshing {
        _refreshTokens { [weak self] succeeded, response in
          guard let strongSelf = self else { return }
          guard let response = response else { return }
          strongSelf.lock.lock() ; defer { strongSelf.lock.unlock() }

          CitySessionManager.shared.idToken = response.data.idToken
          CitySessionManager.shared.accessToken = response.data.accessToken

          strongSelf.requestsToRetry.forEach { $0(succeeded, 0.0) }
          strongSelf.requestsToRetry.removeAll()
        }
      }
    } else {
      completion(false, 0.0)
    }
  }

  private func _refreshTokens(completion: @escaping RefreshCompletion) {
    guard let refreshToken = CitySessionManager.shared.refreshToken else { return }
    guard !isRefreshing else { return }

    isRefreshing = true

    let authRequest: AuthRequest = AuthRequest(refreshToken: refreshToken)

    // CityOS.shared.session.request(Router.refreshToken(auth: authRequest))
    Alamofire.request(Router.refreshToken(auth: authRequest)).validate().responseObject {
        [weak self] (result: Result<RefreshTokenResponse>, response: DataResponse<Any>) in
      guard let strongSelf = self else { return }

      switch result {
      case .success(let response):
        completion(true, response)
      case .failure(let error):
        log.error("error: \(error)")
        completion(false, nil)
      }
      
      strongSelf.isRefreshing = false
    }
  }
}
