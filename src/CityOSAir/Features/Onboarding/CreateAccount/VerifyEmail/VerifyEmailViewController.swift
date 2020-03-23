//
//  VerifyEmailViewController.swift
//  CityOSAir
//
//  Created by Haris Kovacevic on 05/06/2019.
//  Copyright © 2019 CityOS. All rights reserved.
//

import UIKit


class VerifyEmailViewController: UIViewController {
  lazy var contentView = VerifyEmailContentView.autolayoutView()
  var email = " "

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    title = "verify_email_screen_verify_your_email_title".localized()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
  }
}


extension VerifyEmailViewController {
  func setupViews() {
    view.addSubview(contentView)
    contentView.snp.makeConstraints {
      $0.edges.equalTo(view)
      $0.centerX.equalTo(view)
      $0.centerY.equalTo(view)
    }
    contentView.email = email
    contentView.setupEmail()
  }
}

