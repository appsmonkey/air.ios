//
//  AQIContentView.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 1/4/20.
//  Copyright © 2020 CityOS. All rights reserved.
//

import UIKit

class AQIContentView: UIView {
  let tableView = UITableView(frame: .zero, style: .plain).autolayoutView()
  let backButton = UIButton().autolayoutView()
  let headerLabel = UILabel().autolayoutView()
  let subtitleLabel = UILabel().autolayoutView()
  let lineView = UIView().autolayoutView()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension AQIContentView {
  func setupViews() {
    backgroundColor = .white
    
    setupBackButton()
    setupHeaderLabel()
    setupSubtitleLabel()
    setupLineView()
    setupTableView()
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
    
    headerLabel.snp.makeConstraints {
      $0.centerY.equalTo(backButton)
      $0.centerX.equalTo(self)
    }
  }
  
  func setupSubtitleLabel() {
    addSubview(subtitleLabel)
    
    subtitleLabel.font = Styles.Detail.SubtitleText.font
    subtitleLabel.textColor = Styles.Detail.SubtitleText.tintColor
    subtitleLabel.textAlignment = .center
    subtitleLabel.numberOfLines = 0
    
    subtitleLabel.snp.makeConstraints {
      $0.centerX.equalTo(headerLabel)
      $0.top.equalTo(headerLabel.snp.bottom).offset(10)
      $0.left.equalTo(self).offset(20)
      $0.right.equalTo(self).offset(-20)
    }
  }
  
  func setupLineView() {
    addSubview(lineView)
    
    lineView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.7)
    lineView.isHidden = true

    lineView.snp.makeConstraints {
      $0.top.equalTo(subtitleLabel.snp.bottom).offset(8)
      $0.height.equalTo(0.5)
    }
  }
  
  func setupTableView() {
    addSubview(tableView)
    
    tableView.register(AQITableViewCell.self, forCellReuseIdentifier: "Cell")
    tableView.tableFooterView = UIView()
    tableView.separatorStyle = .none
    tableView.bounces = false
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 400
    
    tableView.snp.makeConstraints {
      $0.top.equalTo(lineView.snp.bottom).offset(8)
      $0.left.equalTo(self)
      $0.right.equalTo(self)
      $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
    }
  }
  
  func setPM10() {
    headerLabel.text = Text.PM10.title
    subtitleLabel.text = Text.PM10.subtitle
  }
  
  func setPM25() {
    
    let attributedTitle = NSMutableAttributedString(string: Text.PM25.title,
                                                    attributes: [NSAttributedString.Key.font: Styles.Detail.HeaderText.font])
    
    attributedTitle.setAttributes([NSAttributedString.Key.font: Styles.Detail.HeaderText.subscriptFont,
                                   NSAttributedString.Key.baselineOffset: -10], range: NSRange(location: 2, length: 3))
    
    headerLabel.attributedText = attributedTitle
    
    let attributedSubtitle = NSMutableAttributedString(string: Text.PM25.subtitle,
                                                       attributes: [NSAttributedString.Key.font: Styles.Detail.SubtitleText.font])
    
    attributedSubtitle.setAttributes([NSAttributedString.Key.font: Styles.Detail.SubtitleText.subscriptFont,
                                      NSAttributedString.Key.baselineOffset: -5], range: NSRange(location: 16, length: 3))
    
    subtitleLabel.attributedText = attributedSubtitle
  }
}
