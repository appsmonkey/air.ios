//
//  ConfigureDeviceContentView.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 12/25/19.
//  Copyright © 2019 CityOS. All rights reserved.
//

import UIKit
import WebKit
import SnapKit

class ConfigureDeviceContentView: UIView {
  let closeButton = UIButton().autolayoutView()
  let headerLabel = UILabel().autolayoutView()
  let webView = WKWebView().autolayoutView()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

extension ConfigureDeviceContentView {
  func setupViews() {
    backgroundColor = .white
    
    setupCloseButton()
    setupHeaderLabel()
    setupWebView()
  }
  
  func setupCloseButton() {
    addSubview(closeButton)
    
    closeButton.setImage(UIImage(named: "close"), for: .normal)
    
    closeButton.snp.makeConstraints {
      $0.width.equalTo(64)
      $0.height.equalTo(64)
      $0.right.equalTo(self)
      $0.top.equalTo(safeAreaLayoutGuide.snp.top)
    }
  }
  
  func setupHeaderLabel() {
    addSubview(headerLabel)
    
    headerLabel.textAlignment = .center
    headerLabel.text = "Configure Device"
    headerLabel.numberOfLines = 0
    headerLabel.font = Styles.Detail.HeaderText.font
    headerLabel.textColor = Styles.Detail.HeaderText.tintColor
    
    headerLabel.snp.makeConstraints {
      $0.centerY.equalTo(closeButton)
      $0.centerX.equalTo(self)
    }
  }
  
  func setupWebView() {
    addSubview(webView)
    
    webView.snp.makeConstraints {
      $0.top.equalTo(closeButton.snp.bottom)
      $0.left.equalTo(self)
      $0.right.equalTo(self)
      $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
    }
  }
}
