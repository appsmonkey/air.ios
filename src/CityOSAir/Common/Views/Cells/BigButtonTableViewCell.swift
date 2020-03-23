//
//  BigButtonTableViewCell.swift
//  CityOSAir
//
//  Created by Andrej Saric on 28/08/16.
//  Copyright © 2016 CityOS. All rights reserved.
//

import UIKit

class BigButtonTableViewCell: UITableViewCell {

  let button: UIButton = {
    let btn = UIButton()

    btn.setTitle(Text.Buttons.continueBtn, for: UIControl.State())
    btn.backgroundColor = Styles.BigButton.backgroundColor
    btn.tintColor = Styles.BigButton.tintColor
    btn.titleLabel?.font = Styles.BigButton.font

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

    // Configure the view for the selected state
  }

  fileprivate func initialize(backgroundColor: UIColor? = nil) {

    if let backgroundColor = backgroundColor {
      button.backgroundColor = backgroundColor
    }

    selectionStyle = .none

    contentView.addSubview(button)

    contentView.addConstraintsWithFormat("V:|-20-[v0]-20-|", views: button)
    contentView.addConstraintsWithFormat("H:|-20-[v0]-20-|", views: button)

  }

}

extension BigButtonTableViewCell: Reusable { }
