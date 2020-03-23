//
//  LoginContentView.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 11/28/19.
//  Copyright © 2019 CityOS. All rights reserved.
//

import UIKit
import SnapKit

class LoginContentView: UIView {
  let tableView = UITableView(frame: .zero, style: .plain).autolayoutView()
  let continueButton = UIButton().autolayoutView()

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension LoginContentView {
  func setupViews() {
    backgroundColor = .white
    setupTableView()
    setupButtonView()
  }

  func setupTableView() {
    addSubview(tableView)
    tableView.register(InputTableViewCell.self)
    tableView.register(ButtonTableViewCell.self)
    tableView.register(SocialLoginTableViewCell.self)
    tableView.tableFooterView = UIView()
    tableView.separatorStyle = .none
    tableView.alwaysBounceVertical = false

    tableView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }

  func setupButtonView() {
    addSubview(continueButton)
    continueButton.setTitle(title: "login_screen_view_sarajevo_air_button_title".localized())
    continueButton.setType(type: AppButtonType.transparent)

    continueButton.snp.makeConstraints {
      $0.left.equalToSuperview().offset(20)
      $0.bottom.equalToSuperview().offset(-20)
      $0.right.equalToSuperview().offset(-20)
      $0.height.equalTo(60)
    }
  }
}
