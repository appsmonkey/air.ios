//
//  User.swift
//  CityOSAir
//
//  Created by Andrej Saric on 01/09/16.
//  Copyright © 2016 CityOS. All rights reserved.
//

import Foundation
import RealmSwift

class User: Object {

  @objc dynamic var id = 1

  @objc dynamic var userId: Int = 0
  @objc dynamic var email: String = ""
  @objc dynamic var password: String = ""
  @objc dynamic var token: String = ""

  convenience init(json: JSON) {
    self.init()
    self.token = json["token"].stringValue
  }

  override static func primaryKey() -> String? {
    return "id"
  }
}
