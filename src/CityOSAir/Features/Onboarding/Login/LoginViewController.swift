//
//  LoginViewController.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 11/28/19.
//  Copyright (c) 2019 CityOS. All rights reserved.
//

import UIKit
import AirshipKit
import FirebaseAuth
import GoogleSignIn
import FBSDKLoginKit
import FBSDKCoreKit

protocol LoginDisplayLogic: class {
  func displayError(_ error: NetworkError)
  func displayMainController()
}

final class LoginViewController: UIViewController, Progressable {
  var interactor: LoginBusinessLogic?
  var router: LoginRoutingLogic?

  private lazy var contentView = LoginContentView.autolayoutView()
  private let loginDataSource = LoginDataSource()
  var shouldClose = false
  var email = ""
  var password = ""
  var isDeepLink: Bool
  var delegate: LoginRouterDelegate?

  init(delegate: LoginRouterDelegate?, isDeepLink: Bool = false, email: String = "", password: String = "") {
    self.delegate = delegate
    self.isDeepLink = isDeepLink
    self.email = email
    self.password = password
    super.init(nibName: nil, bundle: nil)
    let interactor = LoginInteractor()
    let presenter = LoginPresenter()
    let router = LoginRouter()
    interactor.presenter = presenter
    presenter.viewController = self
    router.viewController = self
    router.delegate = delegate
    self.interactor = interactor
    self.router = router

    loginDataSource.target = self

    _configure()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    updateDataSource()
    
    if isDeepLink {
      isDeepLink = false
      login(email: email, password: password)
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    let closeButton = UIBarButtonItem(image: UIImage(named: "close"), style: .done, target: self, action: #selector(goToWelcomeScreen))
    navigationItem.leftBarButtonItem = closeButton
    navigationController?.setNavigationBarHidden(false, animated: true)
    hideProgressHUD()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(true)
    hideProgressHUD()
  }

  private func _configure() {
    GIDSignIn.sharedInstance().presentingViewController = self
    GIDSignIn.sharedInstance().delegate = self
    hideKeyboardWhenTappedAround()
  }

  private func updateDataSource() {
    loginDataSource.update()
  }
}

// MARK: - Private methods
private extension LoginViewController {
  func setupViews() {
    title = "login_screen_log_into_device_title".localized()

    setupContentView()
  }
  
  @objc func goToWelcomeScreen() {
    router?.presentWelcomeScreen()
  }

  func setupContentView() {
    view.addSubview(contentView)
    contentView.snp.makeConstraints { $0.edges.equalToSuperview() }
    contentView.tableView.delegate = self
    contentView.tableView.dataSource = loginDataSource
    contentView.continueButton.addTarget(self, action: #selector(LoginViewController.continuePressed), for: .touchUpInside)
  }

}

// MARK: - Table Delegate
extension LoginViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return loginDataSource.fields[section].spacing()
  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = UIView()
    headerView.backgroundColor = UIColor.clear
    return headerView
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return loginDataSource.fields[indexPath.section].height()
  }

}

// MARK: - Navigation
extension LoginViewController {
  func login(email: String, password: String) {
    showProgressHUD(with: Text.LogIn.Messages.loadingMsg)
    interactor?.login(email: email, password: password)
  }

  func navigtateMainController() {
    hideProgressHUD()
    if shouldClose {
      delegate?.loggedInFromSideMenu()
      router?.dismis()
    } else {
      router?.presentMainScreen()
    }
  }
}

// MARK: - TextField Delegate
extension LoginViewController: UITextFieldDelegate {
  @objc func loginPressed() {
    self.view.endEditing(true)
    if !email.isEmpty && !password.isEmpty {
      if email.isEmail {
        showProgressHUD(with: Text.LogIn.Messages.loadingMsg)
        login(email: email, password: password)
      } else {
        alert(Text.AccountCreate.Messages.emailError, message: nil, close: "OK", closeHandler: nil)
      }
    } else {
      alert("Please check that all fields are filled out", message: nil, close: "Close", closeHandler: nil)
    }
  }

  @objc func continuePressed() {  
    navigtateMainController()
  }

  @objc
  func signUpPressed() {
    router?.presentSignUp()
  }

  @objc
  func forgotPasswordPressed() {
    router?.presentForgotPassword()
  }

  @objc
  func googleLoginPressed() {
    GIDSignIn.sharedInstance().signIn()
  }

  @objc
  func facebookLoginPressed() {
    let loginManager = LoginManager()
    showProgressHUD(with: Text.LogIn.Messages.loadingMsg)
    loginManager.login(viewController: self) { [weak self] result in
      guard let self = self else { return }
      if result.success {
        self.interactor?.login(email: result.email!, social: Social(id: result.id!, token: result.token!, type: "FB"))
      } else {
        self.hideProgressHUD()
      }
    }
  }

  @objc func loginTextFieldDidChange(_ textfield: UITextField) {
    switch textfield.tag {
    case LoginFormField.email.rawValue:
      email = textfield.text ?? ""
    case LoginFormField.password.rawValue:
      password = textfield.text ?? ""
    default:
      return
    }
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    self.view.endEditing(true)
    return true
  }
}

// MARK: - Google SignIn Delegate
extension LoginViewController: GIDSignInDelegate {
  func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
    if let email = user?.profile.email, let userId = user?.userID, let token = user?.authentication.idToken {
      showProgressHUD(with: Text.LogIn.Messages.loadingMsg)
      interactor?.login(email: email, social: Social(id: userId, token: token, type: "G"))
    }
  }
}

// MARK: - Display Logic
extension LoginViewController: LoginDisplayLogic {
  func displayError(_ error: NetworkError) {
    log.error("login error: \(error)")
    hideProgressHUD()
    router?.navigateToAlert(title: "Login Errror", message: error.message, handler: nil)
    
  }
  
  func displayMainController() {
    hideProgressHUD()
    UAirship.push()?.updateTags(forUserLoggedIn: true)
    navigtateMainController()
  }
  
}
