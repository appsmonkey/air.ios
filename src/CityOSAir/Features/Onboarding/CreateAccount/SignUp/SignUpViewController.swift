//
//  SetupAccountViewController.swift
//  CityOSAir
//
//  Created by Haris Kovacevic on 05/06/2019.
//  Copyright © 2019 CityOS. All rights reserved.
//

import UIKit

protocol SignUpDisplayLogic: class {
  func displayError(_ error: Error)
  func displayLogin()
}

class SignUpViewController: UIViewController, Progressable {
  /// register response
  var email: String?
  var token: String?
  var cognitoId: String?
  
  /// vars
  var firstName: String?
  var lastName: String?
  var password: String?
  var verifyPassword: String?
  var birthday: Int?
  
  var interactor: SignUpBusinessLogic?
  var router: SignUpRoutingLogic?
  
  private lazy var contentView = SignUpContentView.autolayoutView()
  private let signUpDataSource = SignUpDataSource()
  
  init(delegate: SignUpRouterDelegate?) {
    super.init(nibName: nil, bundle: nil)
    let interactor = SignUpInteractor()
    let presenter = SignUpPresenter()
    let router = SignUpRouter()
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
    updateDateSource()
  }

  private func _configure() {
    contentView.tableView.delegate = self
    contentView.tableView.dataSource = signUpDataSource
    hideKeyboardWhenTappedAround()
  }
  
  private func updateDateSource() {
    signUpDataSource.update(viewController: self)
  }
}

// MARK: - Display Logic
extension SignUpViewController: SignUpDisplayLogic {
  func displayError(_ error: Error) {
    log.error(error)
    hideProgressHUD()
    router?.navigateToAlert(title: "Error", message: "Verification link no longer valid.", handler: nil)
  }
  
  func displayLogin() {
    hideProgressHUD()
    navigateToLoginScreen()
  }
}

extension SignUpViewController {

  func setupViews() {
    title = "sign_up_screen_setup_account_title".localized()
    
    setupContentView()
  }
  
  func setupContentView() {
    view.addSubview(contentView)
    
    contentView.snp.makeConstraints {
      $0.top.bottom.left.right.equalTo(0)
    }
  }

  func validate() -> String? {
    if firstName.isNilOrEmpty {
      return "First name is required"
    }
    if lastName.isNilOrEmpty {
      return "Last name is required"
    }
    if password.isNilOrEmpty {
      return "Please enter password"
    }
    if verifyPassword.isNilOrEmpty {
      return "Please confirm password"
    }
    if password! != verifyPassword! {
      return "Password doesn't match"
    }
    if !(password?.isValidPassword)!() {
      return """
                Invalid password format. Password must:
                Contain at least 1 uppercase letter
                Contain at least 1 digit
                Contain at least 1 character
                Be 8 characters long
            """
    }
    guard let birthday = birthday else {
      return "You must pick age"
    }
    guard let age = Calendar.current.dateComponents([.year], from: Date(timeIntervalSince1970: TimeInterval(birthday)), to: Date()).year else {
      return "Not valid age"
    }
    
    if age < 14 {
      return "You must be older than 13 years"
    }

    return nil;
  }

  func createAccount() {
    showProgressHUD(with: "Loading...")
    guard let email = email, let password = password, let token = token, let cognitoId = cognitoId else {
      router?.navigateToAlert(title: "Error", message: "There was an unknown flow error.", handler: nil)
      return
    }
    let profile = UserProfile(firstName: firstName, lastName: lastName, bio: nil, city: nil, gender: nil, birthday: birthday)
    interactor?.register(email: email, password: password, token: token, cognitoId: cognitoId, profile: profile)
  }

  func navigateToLoginScreen() {
    guard let email = email, let password = password else {
      router?.navigateToAlert(title: "Error", message: "There was an unknown flow error.", handler: nil)
      return
    }
    router?.navigateToLoginScreen(email: email, password: password)
  }

}

extension SignUpViewController: UITextFieldDelegate, UITextViewDelegate, DateDelegate {
  @objc func createAccountPressed() {
    if let error = validate() {
      router?.navigateToAlert(title: "Validation Error", message: error, handler: nil)
    } else {
      createAccount()
    }
  }



  @objc func signUpTextFieldDidChange(_ textfield: UITextField) {
    if let formField = SignUpFormField.init(rawValue: textfield.tag), let text = textfield.text {
      switch formField {
      case .firstName:
        firstName = text
      case .lastName:
        lastName = text
      case .password:
        password = text
      case .verifyPassword:
        verifyPassword = text
      default:
        return
      }
    }
  }

  func onDateSelected(_ date: Date) {
    birthday = Int(date.timeIntervalSince1970)
  }


  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    view.endEditing(true)
    return true
  }

  func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
    UIApplication.shared.open(URL)
    return false
  }
}

// MARK: - UITableView Controller
extension SignUpViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return signUpDataSource.fields[section].spacing()
  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = UIView()
    headerView.backgroundColor = UIColor.clear
    return headerView
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return signUpDataSource.fields[indexPath.section].height()
  }

}
