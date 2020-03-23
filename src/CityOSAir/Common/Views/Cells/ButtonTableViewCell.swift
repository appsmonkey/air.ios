//
//  ButtonTableViewCell.swift
//  CityOSAir
//
//  Created by Haris Kovacevic on 05/06/2019.
//  Copyright © 2019 CityOS. All rights reserved.
//

import UIKit

class ButtonTableViewCell: UITableViewCell {
  let button: UIButton = {
    let btn = UIButton()
    return btn
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


  fileprivate func initialize() {
    selectionStyle = .none
    contentView.addSubview(button)
    contentView.addConstraintsWithFormat("V:|[v0]|", views: button)
    contentView.addConstraintsWithFormat("H:|-20-[v0]-20-|", views: button)
  }

  func configure(title: String, type: AppButtonType, target: Any?, action: Selector, tag: Int) -> ButtonTableViewCell {
    self.tag = tag
    self.button.setTitle(title: title)
    self.button.setType(type: type)
    self.button.addTarget(target, action: action, for: .touchUpInside)
    return self
  }

}

extension ButtonTableViewCell: Reusable {
}
