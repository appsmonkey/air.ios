//
//  SetupAccountContentView.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 12/1/19.
//  Copyright © 2019 CityOS. All rights reserved.
//

import UIKit
import SnapKit

class SignUpContentView: UIView {
  let tableView = UITableView(frame: .zero, style: .plain).autolayoutView()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension SignUpContentView {
  func setupViews() {
    setupTableView()
  }
  
  func setupTableView() {
    addSubview(tableView)
    
    tableView.register(InputTableViewCell.self)
    tableView.register(ButtonTableViewCell.self)
    tableView.register(TextTableViewCell.self)
    
    tableView.tableFooterView = UIView()
    tableView.separatorStyle = .none
    tableView.alwaysBounceVertical = false
    
    tableView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
}
