//
//  Profile.swift
//  CityOSAir
//
//  Created by Haris Kovacevic on 03/05/2019.
//  Copyright © 2019 CityOS. All rights reserved.
//

import Foundation
import RealmSwift

struct UserProfile: Codable {
  var firstName: String?
  var lastName: String?
  var bio: String?
  var city: String?
  var gender: String?
  var birthday: Int?

  init(firstName: String?, lastName: String?, bio: String?, city: String?, gender: String?, birthday: Int?) {
    self.firstName = firstName
    self.lastName = lastName
    self.bio = bio
    self.city = city
    self.gender = gender
    self.birthday = birthday
  }

  private enum CodingKeys: String, CodingKey {
    case firstName = "first_name"
    case lastName = "last_name"
    case bio
    case city = "City"
    case gender
  }

}

extension UserProfile: Persistable {
  public init(managedObject: UserProfileObject) {
    firstName = managedObject.firstName
    lastName = managedObject.lastName
    bio = managedObject.bio
    city = managedObject.city
    gender = managedObject.gender
  }

  public func managedObject() -> UserProfileObject {
    let userProfile = UserProfileObject()
    userProfile.firstName = firstName
    userProfile.lastName = lastName
    userProfile.bio = bio
    userProfile.city = city
    userProfile.gender = gender
    return userProfile
  }
}

class UserProfileObject: Object {
  @objc dynamic var id: Int = 0
  @objc dynamic var firstName: String?
  @objc dynamic var lastName: String?
  @objc dynamic var bio: String?
  @objc dynamic var city: String?
  @objc dynamic var gender: String?

  override class func primaryKey() -> String? {
    return "id"
  }
}
