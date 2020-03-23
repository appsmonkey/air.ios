//
//  Token.swift
//  CityOSAir
//
//  Created by Haris Kovacevic on 24/04/2019.
//  Copyright © 2019 CityOS. All rights reserved.
//

import Foundation
import RealmSwift

struct Token: Codable {
  var idToken: String
  var accessToken: String
  var refreshToken: String
}

extension Token: Persistable {
  public init(managedObject: TokenObject) {
    idToken = managedObject.idToken
    accessToken = managedObject.accessToken
    refreshToken = managedObject.refreshToken
  }
  public func managedObject() -> TokenObject {
    let token = TokenObject()
    token.idToken = idToken
    token.accessToken = accessToken
    token.refreshToken = refreshToken
    return token
  }
}

class TokenObject: Object {
  @objc dynamic var id: Int = 0;
  @objc dynamic var idToken: String = " "
  @objc dynamic var accessToken: String = " "
  @objc dynamic var refreshToken: String = " "

  override class func primaryKey() -> String? {
    return "id"
  }
}

struct RefreshToken: Codable {
  var refreshToken: String
}
