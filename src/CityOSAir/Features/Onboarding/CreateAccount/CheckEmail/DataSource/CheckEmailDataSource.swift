//
//  CheckEmailDataSource.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 1/9/20.
//  Copyright © 2020 CityOS. All rights reserved.
//

import UIKit

class CheckEmailDataSource: NSObject, DataSource {
  var sections = [CheckEmailSection]()
  let fields: [CreateAccountFormField] = [.email, .signup]
  
  weak var target: CheckEmailViewController?
  
  func update(viewController: CheckEmailViewController) {
    target = viewController
    buildSections()
  }
}

// MARK: - UITableview DataSource
extension CheckEmailDataSource: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return numberOfSections()
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return numberOfRows(in: section)
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let fieldType: CreateAccountFormField = fields[indexPath.section]

    switch fieldType {
    case .email:
      let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as InputTableViewCell
      return cell.configure(
        placeholder: Text.Placeholders.email,
        tag: fieldType.rawValue,
        target: target,
        action: #selector(CheckEmailViewController.textFieldDidChange(_:)),
        isSecure: false
      )

    case .signup:
      let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as ButtonTableViewCell
      return cell.configure(
        title: Text.ResetPassword.Button.continueTitle,
        type: .normal,
        target: target,
        action: #selector(CheckEmailViewController.signUpPressed),
        tag: fieldType.rawValue
      )
    }
  }
  
}

// MARK: - Private Methods

private extension CheckEmailDataSource {
  func buildSections() {
    for row in CreateAccountFormField.allCases {
      let sectionRow = CheckEmailRow.field(row)
      sections.append(CheckEmailSection(rows: [sectionRow]))
    }
  }
}

enum CreateAccountFormField: Int, CaseIterable {
  case email
  case signup

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
    case .signup:
      return 20.0
    default:
      return 8.0
    }
  }
}
