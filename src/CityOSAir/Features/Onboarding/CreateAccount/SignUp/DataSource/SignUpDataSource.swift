//
//  SignUpDataSource.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 12/2/19.
//  Copyright © 2019 CityOS. All rights reserved.
//

import UIKit

class SignUpDataSource: NSObject, DataSource {
  var sections = [SignUpSection]()
  let fields: [SignUpFormField] = [.firstName, .lastName, .password, .verifyPassword, .birthday, .createAccount, .terms]
  
  weak var target: SignUpViewController?
  
  func update(viewController: SignUpViewController) {
    target = viewController
    buildSections()
  }
}

// MARK: - UITableview DataSource
extension SignUpDataSource: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return numberOfSections()
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return numberOfRows(in: section)
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let fieldType: SignUpFormField = fields[indexPath.section]
    
    switch fieldType {
    case .firstName:
      let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as InputTableViewCell
      return cell.configure(
        placeholder: Text.Placeholders.firstName,
        tag: fieldType.rawValue,
        target: target,
        action: #selector(target?.signUpTextFieldDidChange(_:)),
        isSecure: false
      )
      
    case .lastName:
      let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as InputTableViewCell
      return cell.configure(
        placeholder: Text.Placeholders.lastName,
        tag: fieldType.rawValue,
        target: target,
        action: #selector(target?.signUpTextFieldDidChange(_:)),
        isSecure: false
      )
      
    case .password:
      let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as InputTableViewCell
      return cell.configure(
        placeholder: Text.Placeholders.password,
        tag: fieldType.rawValue,
        target: target,
        action: #selector(target?.signUpTextFieldDidChange(_:)),
        isSecure: true
      )
      
    case .verifyPassword:
      let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as InputTableViewCell
      return cell.configure(
        placeholder: Text.Placeholders.verifyPassword,
        tag: fieldType.rawValue,
        target: target,
        action: #selector(target?.signUpTextFieldDidChange(_:)),
        isSecure: true
      )
      
    case .birthday:
      let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as InputTableViewCell
      return cell.configure(
        placeholder: Text.Placeholders.birthday,
        tag: fieldType.rawValue,
        withDatePickerMode: .date,
        delegate: target
      )
      
    case .createAccount:
      let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as ButtonTableViewCell
      return cell.configure(
        title: "Create Account",
        type: .normal,
        target: target,
        action: #selector(target?.createAccountPressed),
        tag: fieldType.rawValue
      )
      
    case .terms:
      let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as TextTableViewCell
      cell.textview.delegate = target
      cell.textview.isSelectable = true
      cell.textview.textAlignment = .center
      cell.textview.attributedText = "By clicking 'Create account', you agree to our Terms of Service and Privacy Policy."
        .attributedString(attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18.0)])
        .makeLink(string: "Terms of Service", link: "https://cityos.io/terms.static")
        .makeLink(string: "Privacy Policy", link: "https://cityos.io/privacy.static")
      return cell
    }
  }
  
}

// MARK: - Private Methods

private extension SignUpDataSource {
  func buildSections() {
    for row in SignUpFormField.allCases {
      let sectionRow = SignUpRow.field(row)
      sections.append(SignUpSection(rows: [sectionRow]))
    }
  }
}

enum SignUpFormField: Int, CaseIterable {
  case firstName = 0
  case lastName
  case password
  case verifyPassword
  case birthday
  case createAccount
  case terms
  
  func height() -> CGFloat {
    let delta = UIDevice.delta
    switch self {
    case .terms:
      return 100
    case .createAccount:
      return 60
    default:
      return 30 * delta
    }
  }
  
  func spacing() -> CGFloat {
    switch self {
    case .createAccount:
      return 30.0
    default:
      return 8.0
    }
  }
}
