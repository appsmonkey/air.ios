//
//  SensorDataSource.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 11/28/19.
//  Copyright © 2019 CityOS. All rights reserved.
//

import UIKit

class LoginDataSource: NSObject, DataSource {
  var sections = [LoginSection]()
  let fields: [LoginFormField] = [.email, .password, .forgotPassword, .login, .socialLogin, .signUpEmail]

  weak var target: LoginViewController?

  func update() {
    buildSections()
  }
}

// MARK: - UICollectionView DataSource
extension LoginDataSource: UITableViewDataSource {

  func numberOfSections(in tableView: UITableView) -> Int {
    return numberOfSections()
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return numberOfRows(in: section)
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let fieldType: LoginFormField = fields[indexPath.section]

    switch fieldType {
    case .email:
      let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as InputTableViewCell
      return cell.configure(
        placeholder: Text.Placeholders.email,
        tag: fieldType.rawValue,
        target: target,
        action: #selector(LoginViewController.loginTextFieldDidChange(_:)),
        isSecure: false
      )

    case .password:
      let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as InputTableViewCell
      return cell.configure(
        placeholder: Text.Placeholders.password,
        tag: fieldType.rawValue,
        target: target,
        action: #selector(LoginViewController.loginTextFieldDidChange(_:)),
        isSecure: true
      )

    case .forgotPassword:
      let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as ButtonTableViewCell
      return cell.configure(
        title: Text.LogIn.Buttons.forgotPassword,
        type: .label,
        target: target,
        action: #selector(LoginViewController.forgotPasswordPressed),
        tag: fieldType.rawValue
      )

    case .login:
      let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as ButtonTableViewCell
      return cell.configure(
        title: Text.LogIn.Buttons.logIn,
        type: .normal,
        target: target,
        action: #selector(LoginViewController.loginPressed),
        tag: fieldType.rawValue
      )

    case .socialLogin:
      let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as SocialLoginTableViewCell
      cell.tag = fieldType.rawValue
      cell.googleSignInButton.addTarget(target, action: #selector(LoginViewController.googleLoginPressed), for: .touchUpInside)
      cell.facebookSignInButton.addTarget(target, action: #selector(LoginViewController.facebookLoginPressed), for: .touchUpInside)
      return cell;

    case .signUpEmail:
      let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as ButtonTableViewCell
      return cell.configure(
        title: Text.LogIn.Buttons.signUpWithEmail,
        type: .label,
        target: target,
        action: #selector(LoginViewController.signUpPressed),
        tag: fieldType.rawValue
      )

    }
  }

}

// MARK: - Private Methods

private extension LoginDataSource {
  func buildSections() {
    for row in LoginFormField.allCases {
      let sectionRow = LoginRow.field(row)
      sections.append(LoginSection(rows: [sectionRow]))
    }
  }
}

enum LoginFormField: Int, CaseIterable {
  case email
  case password
  case forgotPassword
  case login
  case socialLogin
  case signUpEmail

  func height() -> CGFloat {
    let delta = UIDevice.delta

    switch self {
    case .password, .email:
      return 30 * delta
    case .forgotPassword, .signUpEmail:
      return 25 * delta
    case .socialLogin:
      return 50
    default:
      return 60
    }
  }

  func spacing() -> CGFloat {
    switch self {
    case .forgotPassword, .login:
      return 12.0
    default:
      return 8.0
    }
  }
}
