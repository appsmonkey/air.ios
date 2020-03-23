//
//  DeviceInfoContentView.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 12/1/19.
//  Copyright © 2019 CityOS. All rights reserved.
//

import UIKit
import SnapKit

class MainContentView: UIView {
  let tableView = UITableView(frame: .zero, style: .plain).autolayoutView()
  let lineView = UIView.autolayoutView()
  let menuButton = UIButton.autolayoutView()
  let mapButton = UIButton.autolayoutView()
  let menuButtonTop = UIButton.autolayoutView()
  let mapButtonTop = UIButton.autolayoutView()
  let headerLabel = UILabel.autolayoutView()
  let timeStampLabel = UILabel.autolayoutView()
  let refreshControl = UIRefreshControl.autolayoutView()
  let loadingImageView = UIImageView.autolayoutView()
  let circularGaugeView = CircularGaugeView(frame: CGRect(x: 0, y: 0, width: 224, height: 224)).autolayoutView()
  let loadingGif = UIImage.gif(name: "CityOS_Air_Loading")
  var topPadding: CGFloat = 40
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension MainContentView {
  func setupViews() {
    backgroundColor = .white
        
    setupMenuButton()
    setupMapButton()
    setupHeader()
    setupTimeStamp()
    setupCircularGaugeView()
    setupLoadingImageView()
    // setupLineView()
    setupTableView()
    setupRefreshControl()
    setupMenuButtonTop()
    setupMapButtonTop()
  }
  
  func setupMenuButton() {
    addSubview(menuButton)
    
    menuButton.setImage(UIImage(named: "menu"), for: UIControl.State())
    menuButton.tintColor = UIColor.gray
    
    menuButton.snp.makeConstraints {
      $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(10)
      $0.left.equalTo(15)
      $0.height.equalTo(30)
      $0.width.equalTo(30)
    }
  }
  
  func setupMapButton() {
    addSubview(mapButton)
    
    mapButton.setImage(UIImage(named: "map"), for: UIControl.State())
    mapButton.tintColor = UIColor.gray
    
    mapButton.snp.makeConstraints {
      $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(10)
      $0.right.equalTo(-15)
      $0.height.equalTo(30)
      $0.width.equalTo(30)
    }
  }
  
  func setupHeader() {
    addSubview(headerLabel)
    
    headerLabel.textAlignment = .center
    headerLabel.font = Styles.Detail.HeaderText.font
    headerLabel.textColor = Styles.Detail.HeaderText.tintColor
    headerLabel.numberOfLines = 0
    
    headerLabel.snp.makeConstraints {
      $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(10)
      $0.left.equalTo(menuButton.snp.right).offset(5)
      $0.right.equalTo(mapButton.snp.left).offset(-5)
    }
  }
  
  func setupTimeStamp() {
    addSubview(timeStampLabel)
    
    timeStampLabel.font = Styles.Detail.SubtitleText.font
    timeStampLabel.textColor = Styles.Detail.SubtitleText.tintColor
    
    timeStampLabel.snp.makeConstraints {
      $0.top.equalTo(headerLabel.snp.bottom).offset(20)
      $0.centerX.equalToSuperview()
    }
  }
  
  func setupCircularGaugeView() {
    addSubview(circularGaugeView)
    
    circularGaugeView.snp.makeConstraints {
      $0.top.equalTo(timeStampLabel.snp.bottom).offset(20)
      $0.width.height.equalTo(224)
      $0.centerX.equalToSuperview()
    }
  }
  
  func setupLoadingImageView() {
    addSubview(loadingImageView)
    
    loadingImageView.snp.makeConstraints {
      $0.width.height.equalTo(224)
      $0.centerX.equalTo(circularGaugeView.snp.centerX)
      $0.centerY.equalTo(circularGaugeView.snp.centerY)
    }
  }

  
  func setupLineView() {
    addSubview(lineView)
    
    lineView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.7)
    lineView.isHidden = true
    
    lineView.snp.makeConstraints {
      $0.height.equalTo(0.5)
      $0.top.equalTo(10)
      $0.width.equalToSuperview()
    }
  }
  
  func setupTableView() {
    addSubview(tableView)
    
    tableView.register(ReadingTableViewCell.self)
    tableView.register(ExtendedReadingTableViewCell.self)
    tableView.tableFooterView = UIView()
    tableView.alwaysBounceVertical = false
    tableView.backgroundColor = .clear
    tableView.separatorColor = UIColor.fromHex("EFEFEF")
    
    tableView.snp.makeConstraints {
      $0.top.equalTo(circularGaugeView.snp.bottom).offset(20)
      $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
      $0.left.right.equalToSuperview()
    }
  }
  
  func setupRefreshControl() {
    tableView.addSubview(refreshControl)
    
    refreshControl.tintColor = UIColor.fromHex("b0b0b0")
    refreshControl.attributedTitle = NSAttributedString(string: "device_info_screen_updating_data_refresh_title".localized(),
                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.fromHex("b0b0b0")])
  }
    
  func startAnimatingLoading() {
    loadingImageView.image = loadingGif
    circularGaugeView.isHidden = true
    loadingImageView.isHidden = false
    loadingImageView.startAnimating()
  }
  
  func stopAnimatingLoading() {
    loadingImageView.stopAnimating()
    loadingImageView.image = nil
    loadingImageView.isHidden = true
    circularGaugeView.isHidden = false
  }
  
  func setupMenuButtonTop() {
    addSubview(menuButtonTop)
    
    menuButtonTop.setImage(UIImage(named: "menu"), for: UIControl.State())
    menuButtonTop.tintColor = UIColor.gray
    
    
    menuButtonTop.snp.makeConstraints {
      $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(10)
      $0.left.equalTo(15)
      $0.height.equalTo(30)
      $0.width.equalTo(30)
    }
  }
  
  func setupMapButtonTop() {
    addSubview(mapButtonTop)
    
    mapButtonTop.setImage(UIImage(named: "map"), for: UIControl.State())
    mapButtonTop.tintColor = UIColor.gray
    
    mapButtonTop.snp.makeConstraints {
      $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(10)
      $0.right.equalTo(-15)
      $0.height.equalTo(30)
      $0.width.equalTo(30)
    }
  }
}
