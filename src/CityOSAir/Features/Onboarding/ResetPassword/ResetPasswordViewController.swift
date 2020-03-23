//
//  ForgotPasswordViewController.swift
//  CityOSAir
//
//  Created by Haris Kovacevic on 29/05/2019.
//  Copyright © 2019 CityOS. All rights reserved.
//

import UIKit

// MARK: - Display Protocols
protocol ResetPasswordDisplayLogic: class {
  func displayError(_ error: String)
  func displayAlert(_ message: String)
}

class ResetPasswordViewController: UIViewController, Progressable {
  var interactor: ResetPasswordBusinessLogic?
  var router: ResetPasswordRoutingLogic?
  
  var email: String?
  
  private lazy var contentView = ResetPasswordContentView.autolayoutView()
  private let resetPasswordDataSource = ResetPasswordDataSource()
  
  init(delegate: ResetPasswordRouterDelegate?) {
    super.init(nibName: nil, bundle: nil)
    let interactor = ResetPasswordInteractor()
    let presenter = ResetPasswordPresenter()
    let router = ResetPasswordRouter()
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
    updateDataSource()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    self.title = Text.ResetPassword.title
  }
  
  private func _configure() {
    contentView.tableView.delegate = self
    contentView.tableView.dataSource = resetPasswordDataSource
    hideKeyboardWhenTappedAround()
  }
  
  private func updateDataSource() {
    resetPasswordDataSource.update(viewController: self)
  }
}

extension ResetPasswordViewController {

  private func setViews() {
    view.addSubview(contentView)
    
    contentView.tableView.snp.makeConstraints { $0.edges.equalTo(view) }
  }

  private func openChangePassword() {
    let controller = ChangePasswordViewController(delegate: nil)
    controller.email = email
    navigationController?.pushViewController(controller, animated: true)

  }
}

extension ResetPasswordViewController: UITextFieldDelegate {
  @objc func resetPressed() {
    if let email = self.email {
      showProgressHUD(with: "Loading...")
      interactor?.forgotPasswordStart(email)
    }

  }

  @objc func textFieldDidChange(_ textfield: UITextField) {
    switch textfield.tag {
    case ResetPasswordFormField.email.rawValue:
      self.email = textfield.text
    default:
      return
    }
  }

}

// MARK: - UITableView Delegate
extension ResetPasswordViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return resetPasswordDataSource.fields[section].spacing()
  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = UIView()
    headerView.backgroundColor = UIColor.clear
    return headerView
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return resetPasswordDataSource.fields[indexPath.section].height()
  }

}

extension ResetPasswordViewController: ResetPasswordDisplayLogic {
  
  func displayAlert(_ message: String) {
    hideProgressHUD()
    router?.navigateToAlert(title: "Message", message: message, handler: nil)
  }
  
  func displayError(_ error: String) {
    hideProgressHUD()
    router?.navigateToAlert(title: "Error", message: error, handler: nil)
  }
}
