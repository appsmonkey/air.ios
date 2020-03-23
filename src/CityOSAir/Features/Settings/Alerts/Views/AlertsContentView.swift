//
//  AlertsContentView.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 1/4/20.
//  Copyright © 2020 CityOS. All rights reserved.
//

import UIKit

class AlertsContentView: UIView {
  let backButton = UIButton().autolayoutView()
  let headerLabel = UILabel().autolayoutView()
  let lineView = UIView().autolayoutView()
  let tableView = UITableView(frame: .zero, style: .plain).autolayoutView()
  let pmIndexSlider = PmIndexAlertsSlider().autolayoutView()
  let alertsInfoLabel = UILabel().autolayoutView()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension AlertsContentView {
  func setupViews() {
    backgroundColor = .white
    
    setupBackButton()
    setupHeaderLabel()
    setupLineView()
    setupTableView()
    setupPmIndexSlider()
    setupAlertsInfoLabel()
  }
  
  func setupBackButton() {
    addSubview(backButton)
    
    backButton.setImage(UIImage(named: "backbtn"), for: UIControl.State())
    backButton.tintColor = UIColor.gray
    
    backButton.snp.makeConstraints {
      $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(15)
      $0.left.equalTo(self).offset(16)
    }
  }
  
  func setupHeaderLabel() {
    addSubview(headerLabel)
    
    headerLabel.font = Styles.Detail.HeaderText.font
    headerLabel.textColor = Styles.Detail.HeaderText.tintColor
    headerLabel.text = Text.Settings.title
    
    headerLabel.snp.makeConstraints {
      $0.centerY.equalTo(backButton)
      $0.centerX.equalTo(self)
    }
  }
  
  func setupLineView() {
    addSubview(lineView)
    
    lineView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.7)
    
    lineView.snp.makeConstraints {
      $0.top.equalTo(headerLabel.snp.bottom).offset(8)
      $0.left.equalTo(self)
      $0.right.equalTo(self)
      $0.height.equalTo(0.5)
    }
  }
  
  func setupTableView() {
    addSubview(tableView)
    
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    tableView.register(AlertTableViewCell.self)
    tableView.allowsMultipleSelection = false
    tableView.tableFooterView = UIView()
    tableView.separatorColor = .white
    tableView.backgroundColor = UIColor(red: 0.94, green: 0.94, blue: 0.96, alpha: 1.00)
    tableView.alwaysBounceVertical = false
    
    tableView.snp.makeConstraints {
      $0.top.equalTo(lineView.snp.bottom)
      $0.left.equalTo(self)
      $0.right.equalTo(self)
      $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-self.frame.height / 2)
    }
  }
  
  func setupPmIndexSlider() {
    addSubview(pmIndexSlider)
    
    pmIndexSlider.sections = 4
    pmIndexSlider.backgroundColor = .white
    pmIndexSlider.viewBackgroundColor = UIColor(red: 242, green: 233, blue: 233, alpha: 1.0)
    pmIndexSlider.sliderBackgroundColor = .lightGray
    pmIndexSlider.sliderColor = .gray
    
    pmIndexSlider.snp.makeConstraints {
      $0.height.equalTo(80 * 4)
      $0.width.equalTo(120)
      $0.top.equalTo(lineView.snp.bottom)
      $0.right.equalTo(self).offset(-10)
    }
  }
  
  func setupAlertsInfoLabel() {
    addSubview(alertsInfoLabel)
    
    alertsInfoLabel.numberOfLines = 0
    alertsInfoLabel.text = Text.Settings.AirAlerts.footer
    alertsInfoLabel.font = Styles.SettingsCell.subtitleFont
    alertsInfoLabel.textColor = Styles.SettingsCell.subtitleColor
    
    alertsInfoLabel.snp.makeConstraints {
      $0.top.equalTo(pmIndexSlider.snp.bottom).offset(10)
      $0.left.equalTo(self.snp.left).offset(10)
      $0.right.equalTo(self.snp.right).offset(-10)
    }
  }
  
}
