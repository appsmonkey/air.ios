//
//  WelcomeContentView.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 12/1/19.
//  Copyright © 2019 CityOS. All rights reserved.
//

import UIKit
import SnapKit

class WelcomeContentView: UIView {
  let backgroundImageView = UIImageView.autolayoutView()
  let logoImageView = UIImageView.autolayoutView()
  let signUpButton = UIButton().autolayoutView()
  let continueButton = UIButton().autolayoutView()

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension WelcomeContentView {
  func setupViews() {
    setupBackgroundImage()
    setupLogoImage()
    setupContinueButton()
    setupSignUpButton()
  }

  func setupBackgroundImage() {
    addSubview(backgroundImageView)
    backgroundImageView.contentMode = UIView.ContentMode.scaleAspectFill
    backgroundImageView.clipsToBounds = true
    backgroundImageView.image = UIImage(named: "launch-bg")
    backgroundImageView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }

  func setupLogoImage() {
    addSubview(logoImageView)
    logoImageView.image = UIImage(named: "air-logo")
    logoImageView.contentMode = UIView.ContentMode.scaleAspectFit
    logoImageView.snp.makeConstraints {
      $0.width.equalTo(276)
      $0.height.equalTo(246)
      $0.centerX.equalToSuperview()
      $0.centerY.equalToSuperview().offset(-60)
    }
  }

  func setupContinueButton() {
    addSubview(continueButton)
    continueButton.setTitle("welcome_scrreen_view_sarajevo_air_button_title".localized(), for: UIControl.State())
    continueButton.setType(type: AppButtonType.secondary)
    continueButton.snp.makeConstraints {
      $0.left.equalToSuperview().offset(24)
      $0.bottom.equalToSuperview().offset(-20)
      $0.right.equalToSuperview().offset(-24)
      $0.height.equalTo(60)
    }
  }

  func setupSignUpButton() {
    addSubview(signUpButton)
    signUpButton.setTitle("welcome_sceren_log_into_device_button_title".localized(), for: UIControl.State())
    signUpButton.setType(type: AppButtonType.normal)
    signUpButton.snp.makeConstraints {
      $0.left.equalToSuperview().offset(24)
      $0.bottom.equalTo(self.continueButton.snp.top).offset(-10)
      $0.right.equalToSuperview().offset(-24)
      $0.height.equalTo(60)
    }
  }
}
