//
//  ChangePasswordDataSource.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 1/9/20.
//  Copyright © 2020 CityOS. All rights reserved.
//

import UIKit

class ChangePasswordDataSource: NSObject, DataSource {
  var sections = [ChangePasswordSection]()
  let fields: [ChangePasswordFormField] = [.password, .confirmPassword, .submit]
  
  weak var target: ChangePasswordViewController?
  
  func update(viewController: ChangePasswordViewController) {
    target = viewController
    buildSections()
  }
}

// MARK: - UITableview DataSource
extension ChangePasswordDataSource: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return numberOfSections()
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return numberOfRows(in: section)
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let fieldType: ChangePasswordFormField = fields[indexPath.section]

    switch fieldType {
    case .password:
      let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as InputTableViewCell
      return cell.configure(
        placeholder: "Password",
        tag: fieldType.rawValue,
        target: target,
        action: #selector(ResetPasswordViewController.textFieldDidChange(_:)),
        isSecure: true
      )

    case .confirmPassword:
      let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as InputTableViewCell
      return cell.configure(
        placeholder: "Confirm password",
        tag: fieldType.rawValue,
        target: target,
        action: #selector(ResetPasswordViewController.textFieldDidChange(_:)),
        isSecure: true
      )



    case .submit:
      let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as ButtonTableViewCell
      return cell.configure(
        title: "Submit",
        type: .normal,
        target: target,
        action: #selector(ResetPasswordViewController.resetPressed),
        tag: fieldType.rawValue
      )
    }
  }
  
}

// MARK: - Private Methods

private extension ChangePasswordDataSource {
  func buildSections() {
    for row in ChangePasswordFormField.allCases {
      let sectionRow = ChangePasswordRow.field(row)
      sections.append(ChangePasswordSection(rows: [sectionRow]))
    }
  }
}

enum ChangePasswordFormField: Int, CaseIterable {
  case password
  case confirmPassword
  case submit

  func height() -> CGFloat {
    let delta = UIDevice.delta

    switch self {
    case .submit:
      return 60
    default:
      return 30 * delta
    }
  }

  func spacing() -> CGFloat {
    switch self {
    case .submit:
      return 20.0
    default:
      return 0.0
    }
  }
}
