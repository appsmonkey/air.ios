//
//  DefinedDevices.swift
//  CityOSAir
//
//  Created by Andrej Saric on 08/02/2017.
//  Copyright © 2017 CityOS. All rights reserved.
//

import Foundation

class DefinedDevices {

  private var devices: [Device] = []

  init() {
    let isSarajevo = UserManager.sharedInstance.currentCity == .sarajevo

    //Sarajevo Air
    let sarajevoAirDevice = Device()
    sarajevoAirDevice.name = Text.Readings.title
    sarajevoAirDevice.id = 1
    sarajevoAirDevice.active = isSarajevo
    sarajevoAirDevice.schemaId = 1
    sarajevoAirDevice.isCityDevice = true

    let belgradeAirDevice = Device()
    belgradeAirDevice.name = "Belgrade Air"
    belgradeAirDevice.id = 3
    belgradeAirDevice.active = !isSarajevo
    belgradeAirDevice.schemaId = 2
    belgradeAirDevice.isCityDevice = true

    let temp = SchemaReading(key: 1, whereType: "air", readingType: "temperature", additional: nil)
    let hum = SchemaReading(key: 2, whereType: "air", readingType: "humidity", additional: nil)
    let temp_feel = SchemaReading(key: 3, whereType: "air", readingType: "temperature_feel", additional: nil)
    let pm1 = SchemaReading(key: 4, whereType: "air", readingType: "pm1", additional: nil)
    let pm25 = SchemaReading(key: 5, whereType: "air", readingType: "pm2.5", additional: nil)
    let pm10 = SchemaReading(key: 6, whereType: "air", readingType: "pm10", additional: nil)

    let readings = [temp, hum, temp_feel, pm1, pm25, pm10]

    let sarajevoSchema = Schema(deviceId: 1, schemaId: 1, schemaReadings: readings)
    let belgradeSchema = Schema(deviceId: 3, schemaId: 2, schemaReadings: readings)

    Cache.sharedCache.saveSchema(schema: sarajevoSchema)
    Cache.sharedCache.saveSchema(schema: belgradeSchema)

    devices.append(sarajevoAirDevice)
    devices.append(belgradeAirDevice)
  }

  public func getPredefinedDevices() -> [Device] {
    return self.devices
  }

}
