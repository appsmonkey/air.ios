//
//  Persistable.swift
//  CityOSAir
//
//  Created by Haris Kovacevic on 15/05/2019.
//  Copyright © 2019 CityOS. All rights reserved.
//

import Foundation
import RealmSwift

public protocol Persistable {
  associatedtype ManagedObject: RealmSwift.Object
  init(managedObject: ManagedObject)
  func managedObject() -> ManagedObject
}
