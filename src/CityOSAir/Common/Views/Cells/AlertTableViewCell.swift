//
//  SwitchTableViewCell.swift
//  CityOSAir
//
//  Created by Andrej Saric on 08/01/2017.
//  Copyright © 2017 CityOS. All rights reserved.
//

import UIKit
import SnapKit

class AlertTableViewCell: UITableViewCell, Reusable {

  let titleLabel: UILabel = {
    let lbl = UILabel()
    lbl.font = Styles.SettingsCell.titleFont
    lbl.textColor = Styles.SettingsCell.titleColor
    lbl.translatesAutoresizingMaskIntoConstraints = false
    lbl.numberOfLines = 0
    return lbl
  }()

  override func awakeFromNib() {
    super.awakeFromNib()
    initialize()
  }

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    initialize()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }

  func configure(label: String) -> AlertTableViewCell {
    self.titleLabel.text = label
    return self
  }

  fileprivate func initialize() {
    self.selectionStyle = .none
    backgroundColor = .white

    contentView.addSubview(titleLabel)
    titleLabel.snp.makeConstraints {
      $0.left.equalTo(contentView.snp.left).offset(25)
      $0.centerY.equalTo(contentView.snp.centerY)
    }
  }
}
