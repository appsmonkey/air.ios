//
//  WelcomeViewController.swift
//  CityOSAir
//
//  Created by Haris Kovacevic on 29/05/2019.
//  Copyright © 2019 CityOS. All rights reserved.
//

import UIKit
import SnapKit

class WelcomeViewController: UIViewController {

  private lazy var contentView = WelcomeContentView.autolayoutView()

  override func viewDidLoad() {
    super.viewDidLoad()

    setupViews()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(true, animated: false)

  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.navigationController?.setNavigationBarHidden(false, animated: false)
  }

}

extension WelcomeViewController {

  func setupViews() {
    view.addSubview(contentView)
    contentView.snp.makeConstraints { $0.edges.equalToSuperview() }

    contentView.signUpButton.addTarget(self, action: #selector(signUpPressed), for: .touchUpInside)
    contentView.continueButton.addTarget(self, action: #selector(continuePressed), for: .touchUpInside)
  }

  @objc
  func signUpPressed() {
    let loginViewcontroller = LoginViewController(delegate: nil)
//    loginViewcontroller.shouldClose = true
    let navigationController = UINavigationController(rootViewController: loginViewcontroller)
    navigationController.modalPresentationStyle = .fullScreen
    present(navigationController, animated: true)
  }

  @objc
  func continuePressed() {
    let deviceViewController = MainViewController(delegate: nil)

    let slideMenuViewController = SlideMenuController(mainViewController: deviceViewController, leftMenuViewController: MenuViewController())
    slideMenuViewController.modalPresentationStyle = .fullScreen
    SlideMenuOptions.contentViewScale = 1
    SlideMenuOptions.hideStatusBar = false

    present(slideMenuViewController, animated: true, completion: nil)
  }
}
