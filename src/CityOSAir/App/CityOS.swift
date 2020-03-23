//
//  CityOS.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 12/23/19.
//  Copyright © 2019 CityOS. All rights reserved.
//

import Alamofire
import RealmSwift

final class CityOS {

// MARK: - Singleton -

  static let shared = CityOS()
  
  var session = SessionManager.default
  
  init() {
    // init authentication handler to renew session once it's expired
    let authHandler = AuthenticationHandler()
    session.adapter = authHandler
    session.retrier = authHandler
  }

  // init schema
  func initializeSchema(completion: @escaping (Bool) -> Void) {
    CityOS.shared.session.request(Router.schema).validate().responseObject { (result: Result<SchemaResponse>, response: DataResponse<Any>) in
      switch result {
      case .success(let schemaResponse):
        var schema = [String: AirSchema]()
        for data in schemaResponse.data {
          let airSchema = AirSchema()
          airSchema.name = data.value.name
          airSchema.unit = data.value.unit
          airSchema.defaultValue = data.value.defaultValue
          airSchema.parsePondition = data.value.parseCondition
          let steps = List<Step>()
          if data.value.steps != nil {
            for dataStep in data.value.steps! {
              let step = Step()
              step.from = dataStep.from
              step.to = dataStep.to
              step.result = dataStep.result
              steps.append(step)
            }
          }
          airSchema.steps = steps
          schema[data.key] = airSchema
        }
        ApplicationManager.shared.saveSchema(schema: schema)
        completion(true)
      case .failure(let error):
        log.info(error)
        completion(false)
      }
    }
  }
  
  // init devices
  func initializeDevices(completion: @escaping (Bool) -> Void) {
    CityOS.shared.session.request(Router.devices).validate().responseObject {
      (result: Result<DevicesResponse>, response: DataResponse<Any>) in
      switch result {
      case .success(let deviceResponse):
        self.persistDevice(deviceResponse: deviceResponse)
        completion(true)
      case .failure(let error):
        log.error(error)
        completion(false)
      }
    }
  }
  
  // store devices to local storage
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
}

