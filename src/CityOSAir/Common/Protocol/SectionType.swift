//
//  SectionType.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 11/28/19.
//  Copyright © 2019 CityOS. All rights reserved.
//

import Foundation

protocol SectionType {
  associatedtype Row: RowType
  var rows: [Row] { get }
}

extension SectionType {
  func row(at index: Int) -> Self.Row? {
    return rows[safe: index]
  }
}
