//
//  SwitchTableViewCell.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 1/6/20.
//  Copyright © 2020 CityOS. All rights reserved.
//

import UIKit

class SwitchTableViewCell: UITableViewCell {
  
  let titleLabel: UILabel = {
    let lbl = UILabel()
    lbl.font = Styles.SettingsCell.titleFont
    lbl.textColor = Styles.SettingsCell.titleColor
    lbl.translatesAutoresizingMaskIntoConstraints = false
    lbl.numberOfLines = 0
    return lbl
  }()
  
  let switchControl: UISwitch = {
    let sw = UISwitch()
    sw.translatesAutoresizingMaskIntoConstraints = false
    sw.isOn = true
    return sw
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
  
  func configure(isOn: Bool, isDisabled: Bool) {
    switchControl.isOn = isOn
    switchControl.isEnabled = !isDisabled
  }
  
  func configure(label:String,isOn: Bool, isDisabled: Bool) -> SwitchTableViewCell {
    self.titleLabel.text = label
    switchControl.isOn = isOn
    switchControl.isEnabled = !isDisabled
    return self
  }
  
  fileprivate func initialize() {
    
    self.selectionStyle = .none
    
    backgroundColor = .white
    
    contentView.addSubview(titleLabel)
    contentView.addSubview(switchControl)
    
    titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25).isActive = true
    
    titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    
    switchControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25).isActive = true
    
    switchControl.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
  }
}

extension SwitchTableViewCell: Reusable {}
