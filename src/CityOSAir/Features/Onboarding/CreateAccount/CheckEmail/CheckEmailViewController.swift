//
//  CreateAccount.swift
//  CityOSAir
//
//  Created by Haris Kovacevic on 05/06/2019.
//  Copyright © 2019 CityOS. All rights reserved.
//

import UIKit
import Alamofire

// MARK: - Display Protocols
protocol CheckEmailDisplayLogic: class {
  func displayError(_ error: String)
  func displayVerifyEmail()
}

class CheckEmailViewController: UIViewController, Progressable {
  var interactor: CheckEmailBusinessLogic?
  var router: CheckEmailRoutingLogic?
  
  var email: String?
  private lazy var contentView = ChecmEmailContentView.autolayoutView()
  private let checkEmailDataSource = CheckEmailDataSource()
  
  init(delegate: CheckEmailRouterDelegate?) {
    super.init(nibName: nil, bundle: nil)
    let interactor = CheckEmailInteractor()
    let presenter = CheckEmailPresenter()
    let router = CheckEmailRouter()
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
    
    setViews()
    updateDateSource()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    self.title = "Create Account"
  }
  
  private func _configure() {
    contentView.tableView.delegate = self
    contentView.tableView.dataSource = checkEmailDataSource
    hideKeyboardWhenTappedAround()
  }

  private func updateDateSource() {
    checkEmailDataSource.update(viewController: self)
  }

}

extension CheckEmailViewController {

  fileprivate func setViews() {
    view.addSubview(contentView)
    
    contentView.tableView.snp.makeConstraints { $0.edges.equalTo(view) }
  }

  fileprivate func continueWithRegistration() {
    let controller = SignUpViewController(delegate: nil)
    controller.email = email
    navigationController?.pushViewController(controller, animated: false)
  }
}

extension CheckEmailViewController: UITextFieldDelegate {
  @objc func signUpPressed() {
    guard let email = self.email else {
      return
    }

    if(!email.isEmail) {
      self.alert("Create account", message: "Please enter valid email", close: "Ok", closeHandler: nil)
      return
    }

    showProgressHUD()
    interactor?.checkEmail(email)
  }

  @objc
  func textFieldDidChange(_ textfield: UITextField) {

    switch textfield.tag {
    case  CreateAccountFormField.email.rawValue:
      email = textfield.text
    default:
      return
    }
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    self.view.endEditing(true)
    return true
  }
}

// MARK: - UITableView Delegate
extension CheckEmailViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return checkEmailDataSource.fields[section].spacing()
  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = UIView()
    headerView.backgroundColor = UIColor.clear
    return headerView
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return checkEmailDataSource.fields[indexPath.section].height()
  }

}

extension CheckEmailViewController: CheckEmailDisplayLogic {
  func displayError(_ error: String) {
    hideProgressHUD()
    router?.navigateToAlert(title: "Error", message: error, handler: nil)
  }
  
  func displayVerifyEmail() {
    hideProgressHUD()
    guard let email = email else {
      router?.navigateToAlert(title: "Error", message: "Pleae enter Email", handler: nil)
      return
    }
    router?.navigateToSignUpScreen(email: email)
  }
}
