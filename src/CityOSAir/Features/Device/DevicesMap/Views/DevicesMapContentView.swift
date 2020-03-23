//
//  MapViewContentView.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 12/17/19.
//  Copyright © 2019 CityOS. All rights reserved.
//

import UIKit
import SnapKit

class DevicesMapContentView: UIView {
  
  let menuButton = UIButton().autolayoutView()
  let chartButton = UIButton().autolayoutView()
  let devicesSegment = CityOSSegmented().autolayoutView()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

extension DevicesMapContentView {
  func setupViews() {
    setupMenuButton()
    setupChartButton()
    setupDevicesSegmen()
  }
  
  func setupMenuButton() {
    addSubview(menuButton)
    
    menuButton.setImage(UIImage(named: "menu-black"), for: UIControl.State())
    
    menuButton.snp.makeConstraints {
      $0.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(8)
      $0.left.equalTo(self).offset(8)
      $0.width.height.equalTo(30)
    }

  }
  
  func setupChartButton() {
    addSubview(chartButton)
    
    chartButton.setImage(UIImage(named: "chart"), for: UIControl.State())
    
    chartButton.snp.makeConstraints {
      $0.centerY.equalTo(menuButton)
      $0.right.equalTo(self).offset(-8)
    }
  }
  
  func setupDevicesSegmen() {
    addSubview(devicesSegment)
    
    let selectedColors = (UIColor.gray, UIColor.white)
    let defaultColors = (UIColor.white, UIColor.gray)
    
    let outdoorSegment = CityOSSegment(title: "Outdoor", defaultColors: defaultColors, selectedColors: selectedColors)
    let indoorSegment = CityOSSegment(title: "Indoor", defaultColors: defaultColors, selectedColors: selectedColors)
    let mineSegment = CityOSSegment(title: "Mine", defaultColors: defaultColors, selectedColors: selectedColors)
    
    devicesSegment.items = [outdoorSegment, indoorSegment, mineSegment]
    
    devicesSegment.snp.makeConstraints {
      $0.centerY.equalTo(menuButton)
      $0.right.equalTo(chartButton.snp.left).offset(-8)
      $0.left.equalTo(menuButton.snp.right).offset(8)
    }
  }
  
}
