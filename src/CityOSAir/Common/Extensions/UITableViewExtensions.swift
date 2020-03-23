//
//  UITableViewExtensions.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 11/28/19.
//  Copyright © 2019 CityOS. All rights reserved.
//

import UIKit

extension UITableView {

  func register<T: UITableViewCell>(_: T.Type) where T: Reusable {
    self.register(T.self, forCellReuseIdentifier: T.identifier)
  }

  func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T where T: Reusable {
    guard let cell = self.dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as? T else {
      fatalError("Could not dequeue cell with identifier: \(T.identifier)")
    }

    return cell
  }
}
