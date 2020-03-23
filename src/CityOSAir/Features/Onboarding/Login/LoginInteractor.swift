//
//  LoginInteractor.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 11/28/19.
//  Copyright (c) 2019 CityOS. All rights reserved.
//

import Alamofire

protocol LoginBusinessLogic {
  func login(email: String, password: String)
  func login(email: String, social: Social)
  func getDevices()
}

class LoginInteractor {
  var presenter: LoginPresentationLogic?
}

// MARK: - Business Logic
extension LoginInteractor: LoginBusinessLogic {
  func login(email: String, social: Social) {
    let credentials = Credentials(email: email, social: social)
    CityOS.shared.session.request(Router.login(credentials: credentials)).validate().debugLog().responseJSON { response in
      var loginSuccess = false
      switch response.result {
      case .success(_):
        loginSuccess = true
        if let data = response.data {
          let decoder = JSONDecoder()
          decoder.keyDecodingStrategy = .convertFromSnakeCase
          do {
            let response = try decoder.decode(LoginResponse.self, from: data)
            self.persistTokens(loginResponse: response, email: email)
          } catch {
            self.presenter?.presentLoginError(NetworkError.General("Network error."))
          }
        }
      case .failure(let err):
        log.error(err)
        if let data = response.data {
          let decoder = JSONDecoder()
          decoder.keyDecodingStrategy = .convertFromSnakeCase
          do {
            let error = try decoder.decode(ApiErrorResponse.self, from: data)
            if let errorMessage = error.errors.first?.errorMessage {
              self.presenter?.presentLoginError(NetworkError.General(errorMessage))
            } else {
              self.presenter?.presentLoginError(NetworkError.General("Network error."))
            }
          } catch {
            self.presenter?.presentLoginError(NetworkError.General("Network error."))
          }
        } else {
          self.presenter?.presentLoginError(NetworkError.General("Network error."))
        }
      }

      guard loginSuccess else { return }

      switch response.result {
      case .success(_):
        self.getDevices()
      case .failure(let error):
        log.error(error)
      }
    }
  }

  func login(email: String, password: String) {
    let credentials = Credentials(email: email, password: password)
    CityOS.shared.session.request(Router.login(credentials: credentials)).debugLog().validate().responseJSON { response in
      var loginSuccess = false
      switch response.result {
      case .success(_):
        loginSuccess = true
        if let data = response.data {
          let decoder = JSONDecoder()
          decoder.keyDecodingStrategy = .convertFromSnakeCase
          do {
            let response = try decoder.decode(LoginResponse.self, from: data)
            self.persistTokens(loginResponse: response, email: email)
          } catch {
            self.presenter?.presentLoginError(NetworkError.General("Failed to decode message from the server."))
          }
        }
      case .failure(let err):
        log.error(err)
        if let data = response.data {
          let decoder = JSONDecoder()
          decoder.keyDecodingStrategy = .convertFromSnakeCase
          do {
            let error = try decoder.decode(ApiErrorResponse.self, from: data)
            if let errorCode = error.errors.first?.errorCode {
              if errorCode == 1050 {
                self.presenter?.presentLoginError(NetworkError.General("This email is already linked with a social account."))
              } else {
                self.presenter?.presentLoginError(NetworkError.General("Invalid username or password."))
              }
            } else {
              self.presenter?.presentLoginError(NetworkError.General("Network error."))
            }
          } catch {
            self.presenter?.presentLoginError(NetworkError.General("Network error."))
          }
        } else {
          self.presenter?.presentLoginError(NetworkError.General("Network error."))
        }
      }

      guard loginSuccess else { return }

      switch response.result {
      case .success(_):
        self.getDevices()
      case .failure(let error):
        log.error(error)
      }
    }
  }

  func getDevices() {
    CityOS.shared.session.request(Router.devices).validate().responseObject {
      (result: Result<DevicesResponse>, response: DataResponse<Any>) in
      var success = false
      switch result {
      case .success(let deviceResponse):
        success = true
        self.persistDevice(deviceResponse: deviceResponse)
      case .failure(let error):
        log.error(error)
        self.presenter?.presentLoginError(NetworkError.General("Failed to get Devices!"))
      }

      guard success else { return }

      switch response.result {
      case .success(_):
        self.presenter?.presentMainController()
      case .failure(let error):
        log.error(error)
      }
    }
  }

  func persistDevice(deviceResponse: DevicesResponse) {
    guard deviceResponse.data.count > 0 else { return }
    let airDevices = deviceResponse.data.map { (data: DevicesResponse.Data) -> AirDevice in
      let mapMeta = data.mapMeta?.mapValues {
        MapMetaReading(level: $0.level, value: $0.value, measurement: $0.measurement, unit: $0.unit)
      }
      return AirDevice(deviceId: data.deviceId, name: data.name, active: data.active, model: data.model,
        indoor: data.indoor, mine: data.mine, defaultDevice: data.defaultDevice,
        location: LatLng(lat: data.location.lat, lng: data.location.lng),
        latest: data.latest, mapMeta: mapMeta, timestamp: data.timestamp)
    }
    DeviceStore.shared.save(devices: airDevices)
  }

  func clearTokens() {
    CitySessionManager.shared.idToken = ""
    CitySessionManager.shared.accessToken = ""
    CitySessionManager.shared.refreshToken = ""
    CitySessionManager.shared.userEmail = ""
  }

  func persistTokens(loginResponse: LoginResponse, email: String) {
    clearTokens()
    CitySessionManager.shared.idToken = loginResponse.data.idToken
    CitySessionManager.shared.accessToken = loginResponse.data.accessToken
    CitySessionManager.shared.refreshToken = loginResponse.data.refreshToken
    CitySessionManager.shared.userEmail = email
  }
}
