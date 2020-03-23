//
//  ConnectDeviceContentView.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 12/19/19.
//  Copyright © 2019 CityOS. All rights reserved.
//

import UIKit
import SnapKit

class ConnectDeviceContentView: UIView {
  
  let closeButton = UIButton().autolayoutView()
  let connectTitle = UILabel().autolayoutView()
  let connectMessage = UILabel().autolayoutView()
  let settingsButton = UIButton().autolayoutView()
  let configureButton = UIButton().autolayoutView()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension ConnectDeviceContentView {
  func setupViews() {
    backgroundColor = .white
    
    setupCloseButton()
    setupConnectTitle()
    setupConnectMessage()
    setupSettingsButton()
    setupConfigureButton()
  }
  
  func setupCloseButton() {
    addSubview(closeButton)
    
    closeButton.setImage(UIImage(named: "close"), for: .normal)
    
    closeButton.snp.makeConstraints {
      $0.width.equalTo(64)
      $0.height.equalTo(64)
      $0.right.equalTo(self)
      $0.top.equalTo(self.safeAreaLayoutGuide.snp.top)
    }
  }
  
  func setupConnectTitle() {
    addSubview(connectTitle)
    
    connectTitle.textAlignment = .center
    connectTitle.text = "Connect Device"
    connectTitle.numberOfLines = 0
    connectTitle.font = Styles.Detail.HeaderText.font
    connectTitle.textColor = Styles.Detail.HeaderText.tintColor
    
    connectTitle.snp.makeConstraints {
      $0.centerY.equalTo(closeButton)
      $0.centerX.equalTo(self)
    }
  }
  
  func setupConnectMessage() {
    addSubview(connectMessage)
    
    connectMessage.textAlignment = .center
    connectMessage.text = "Click on 'Open settings and in your Wifi settings choose Boxy device that you want to configure. After that return to the app and press 'Configure device'. Make sure you are connected to the Boxy before returning to the app and clicking to 'Configure device', otherwise you will receive an error."
    connectMessage.numberOfLines = 0
    connectMessage.font = Styles.Detail.SubtitleText.font
    connectMessage.textColor = Styles.Detail.SubtitleText.tintColor
    
    connectMessage.snp.makeConstraints {
      $0.left.equalTo(self).offset(16.0)
      $0.right.equalTo(self).offset(-16.0)
      $0.top.equalTo(closeButton.snp.bottom).offset(8.0)
    }
  }
  
  func setupSettingsButton() {
    addSubview(settingsButton)
    
    settingsButton.setTitle("Open settings", for: UIControl.State())
    settingsButton.setType(type: AppButtonType.normal)
    
    settingsButton.snp.makeConstraints {
      $0.left.equalTo(self).offset(24.0)
      $0.right.equalTo(self).offset(-24.0)
      $0.height.equalTo(50)
      $0.top.equalTo(connectMessage.snp.bottom).offset(24.0)
    }
  }
  
  func setupConfigureButton() {
    addSubview(configureButton)
    
    configureButton.setTitle("Configure device", for: UIControl.State())
    configureButton.setType(type: AppButtonType.secondary)
    
    configureButton.snp.makeConstraints {
      $0.left.equalTo(self).offset(24.0)
      $0.right.equalTo(self).offset(-24.0)
      $0.height.equalTo(50)
      $0.top.equalTo(settingsButton.snp.bottom).offset(8.0)
    }
  }
  
}
