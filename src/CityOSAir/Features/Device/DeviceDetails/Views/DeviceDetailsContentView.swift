//
//  DeviceDetailsContentView.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 12/25/19.
//  Copyright © 2019 CityOS. All rights reserved.
//

import UIKit
import SnapKit

class DeviceDetailsContentView: UIView {
  let closeButton = UIButton().autolayoutView()
  let headerLabel = UILabel().autolayoutView()
  let tableView = UITableView(frame: .zero, style: .plain).autolayoutView()
  let connectionLabel = UILabel().autolayoutView()
  let doneButton = UIButton().autolayoutView()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension DeviceDetailsContentView {
  
  func setupViews() {
    backgroundColor = .white
    
    setupCloseButton()
    setupHeaderLabel()
    setupTableView()
    setupDoneButton()
  }
  
  func setupCloseButton() {
    addSubview(closeButton)
    
    closeButton.setImage(UIImage(named: "backbtn"), for: .normal)
    
    closeButton.snp.makeConstraints {
      $0.width.equalTo(64)
      $0.height.equalTo(64)
      $0.left.equalTo(self)
      $0.top.equalTo(safeAreaLayoutGuide.snp.top)
    }
  }
  
  func setupHeaderLabel() {
    addSubview(headerLabel)
    
    headerLabel.textAlignment = .center
    headerLabel.text = "Device Info"
    headerLabel.numberOfLines = 0
    headerLabel.font = Styles.Detail.HeaderText.font
    headerLabel.textColor = Styles.Detail.HeaderText.tintColor
    
    
    headerLabel.snp.makeConstraints {
      $0.centerY.equalTo(closeButton)
      $0.centerX.equalTo(self)
    }
  }
  
  func setupTableView() {
    addSubview(tableView)
    
    tableView.register(InputTableViewCell.self)
    tableView.register(SwitchTableViewCell.self)
    
    tableView.tableFooterView = UIView()
    tableView.separatorStyle = .none
    tableView.alwaysBounceVertical = false
    
    tableView.snp.makeConstraints {
      $0.top.equalTo(closeButton.snp.bottom).offset(16.0)
      $0.left.equalTo(self)
      $0.bottom.equalTo(self)
      $0.right.equalTo(self)
    }
  }
  
  func setupDoneButton() {
    addSubview(doneButton)
    
    doneButton.setTitle("Done", for: UIControl.State())
    doneButton.setType(type: AppButtonType.normal)
    
    doneButton.snp.makeConstraints {
      $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-16)
      $0.left.equalTo(self).offset(24)
      $0.right.equalTo(self).offset(-24)
      $0.height.equalTo(50)
    }
  }
}
