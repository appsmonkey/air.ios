//
//  DataSource.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 11/28/19.
//  Copyright © 2019 CityOS. All rights reserved.
//

import Foundation

protocol DataSource {
  associatedtype Section: SectionType
  var sections: [Section] { get set }
}

extension DataSource {
  func section(at index: Int) -> Self.Section? {
    return sections[safe: index]
  }
  
  func numberOfSections() -> Int {
    return sections.count
  }
  
  func numberOfRows(in section: Int) -> Int {
    return self.section(at: section)?.rows.count ?? 0
  }
  
  func row(at indexPath: IndexPath) -> Self.Section.Row? {
    return section(at: indexPath.section)?.row(at: indexPath.row)
  }
}
