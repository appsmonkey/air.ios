//
//  ResetPasswordDataSource.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 1/9/20.
//  Copyright © 2020 CityOS. All rights reserved.
//

import UIKit

class ResetPasswordDataSource: NSObject, DataSource {
  var sections = [ResetPasswordSection]()
  let fields: [ResetPasswordFormField] = [.email, .reset]
  
  weak var target: ResetPasswordViewController?
  
  func update(viewController: ResetPasswordViewController) {
    target = viewController
    buildSections()
  }
}

// MARK: - UITableview DataSource
extension ResetPasswordDataSource: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return numberOfSections()
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return numberOfRows(in: section)
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let fieldType: ResetPasswordFormField = fields[indexPath.section]

    switch fieldType {
    case .email:
      let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as InputTableViewCell
      return cell.configure(
        placeholder: Text.Placeholders.email,
        tag: fieldType.rawValue,
        target: target,
        action: #selector(ResetPasswordViewController.textFieldDidChange(_:)),
        isSecure: false
      )

    case .reset:
      let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as ButtonTableViewCell
      return cell.configure(
        title: Text.ResetPassword.Button.continueTitle,
        type: .normal,
        target: target,
        action: #selector(ResetPasswordViewController.resetPressed),
        tag: fieldType.rawValue
      )
    }
  }
  
}

// MARK: - Private Methods

private extension ResetPasswordDataSource {
  func buildSections() {
    for row in ResetPasswordFormField.allCases {
      let sectionRow = ResetPasswordRow.field(row)
      sections.append(ResetPasswordSection(rows: [sectionRow]))
    }
  }
}

enum ResetPasswordFormField: Int, CaseIterable {
  case email
  case reset

  func height() -> CGFloat {
    let delta = UIDevice.delta

    switch self {
    case .email:
      return 30 * delta
    default:
      return 60
    }
  }

  func spacing() -> CGFloat {
    switch self {
    case .reset:
      return 20.0
    default:
      return 0.0
    }
  }
}
