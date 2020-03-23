//
//  ChangePasswordViewController.swift
//  CityOSAir
//
//  Created by Haris Kovacevic on 11/06/2019.
//  Copyright © 2019 CityOS. All rights reserved.
//

import UIKit

// MARK: - Display Protocols
protocol ChangePasswordDisplayLogic: class {
  func displayError(_ error: String)
  func displayWelcomeScreen()
}


class ChangePasswordViewController: UIViewController, Progressable {
  var email: String?
  var code: String?
  var password: String?
  var confirmPassword: String?
  var token: String?
  var cognitoId: String?

  
  var interactor: ChangePasswordBusinessLogic?
  var router: ChangePasswordRoutingLogic?
  
  private lazy var contentView = ChangePasswordContentView.autolayoutView()
  private let changePasswordDataSource = ChangePasswordDataSource()
  
  init(delegate: ChangePasswordRouterDelegate?) {
    super.init(nibName: nil, bundle: nil)
    let interactor = ChangePasswordInteractor()
    let presenter = ChangePasswordPresenter()
    let router = ChangePasswordRouter()
    interactor.presenter = presenter
    presenter.viewController = self
    router.viewController = self
    router.delegate = delegate
    self.interactor = interactor
    self.router = router
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    _configure()
    
    setupViews()
    updateDataSource()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.title = "Change Password"
  }
  
  private func _configure() {
    contentView.tableView.delegate = self
    contentView.tableView.dataSource = changePasswordDataSource
    hideKeyboardWhenTappedAround()
  }

  private func updateDataSource() {
    changePasswordDataSource.update(viewController: self)
  }
}

extension ChangePasswordViewController {

  private func setupViews() {
    view.addSubview(contentView)
    
    contentView.tableView.snp.makeConstraints { $0.edges.equalTo(view) }
  }
}

extension ChangePasswordViewController: UITextFieldDelegate {
  @objc func resetPressed() {
    if let email = self.email, let password = self.password, let confirmPassword = confirmPassword, let token = token, let cognitoId = cognitoId {
      if !password.isValidPassword() {
        router?.navigateToAlert(title: "Change password", message: """
        Invalid password format.Password must:
        Contain at least 1 uppercase letter
        Contain at least 1 digit
        Contain at least 1 character
        Be 8 characters long
        """, handler: nil)
        return
      }
      guard password == confirmPassword else {
        router?.navigateToAlert(title: "Change password", message: "Password and confirm password do not match", handler: nil)
        return
      }
      showProgressHUD(with: "Loading...")
      interactor?.forgotPasswordEnd(email: email, password: password, token: token, cognitoId: cognitoId)
    }

  }

  @objc func textFieldDidChange(_ textfield: UITextField) {
    switch textfield.tag {
    case ChangePasswordFormField.password.rawValue:
      password = textfield.text
    case ChangePasswordFormField.confirmPassword.rawValue:
      confirmPassword = textfield.text
    default:
      return
    }
  }

}

extension ChangePasswordViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return changePasswordDataSource.fields[section].spacing()
  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = UIView()
    headerView.backgroundColor = UIColor.clear
    return headerView
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return changePasswordDataSource.fields[indexPath.section].height()
  }

}

extension ChangePasswordViewController: ChangePasswordDisplayLogic {
  
  func displayWelcomeScreen() {
    hideProgressHUD()
    router?.navigateToWelcomeScreen()
  }
  
  func displayError(_ error: String) {
    hideProgressHUD()
    router?.navigateToAlert(title: "Error", message: error, handler: nil)
  }
}
