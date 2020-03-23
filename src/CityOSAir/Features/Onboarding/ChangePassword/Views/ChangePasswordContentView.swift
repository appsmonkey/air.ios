//
//  ChangePasswordContentView.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 1/9/20.
//  Copyright © 2020 CityOS. All rights reserved.
//

import UIKit

class ChangePasswordContentView: UIView {
  let tableView = UITableView(frame: .zero, style: .plain).autolayoutView()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

extension ChangePasswordContentView {
  func setupViews() {
    setupTableView()
  }
  
  func setupTableView() {
    addSubview(tableView)
    
    tableView.register(InputTableViewCell.self)
    tableView.register(ButtonTableViewCell.self)
    
    tableView.tableFooterView = UIView()
    tableView.separatorStyle = .none
    tableView.alwaysBounceVertical = false
    
    tableView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
}
