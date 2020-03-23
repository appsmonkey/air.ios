//
//  SettingsTableViewCell.swift
//  CityOSAir
//
//  Created by Andrej Saric on 08/01/2017.
//  Copyright © 2017 CityOS. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

  let titleLabel: UILabel = {
    let lbl = UILabel()
    lbl.font = Styles.SettingsCell.titleFont
    lbl.textColor = Styles.SettingsCell.titleColor
    lbl.translatesAutoresizingMaskIntoConstraints = false
    lbl.numberOfLines = 0
    return lbl
  }()

  let subtitleLabel: UILabel = {
    let lbl = UILabel()
    lbl.font = Styles.SettingsCell.subtitleFont
    lbl.textColor = Styles.SettingsCell.subtitleColor
    lbl.translatesAutoresizingMaskIntoConstraints = false
    lbl.numberOfLines = 0
    lbl.lineBreakMode = .byWordWrapping
    return lbl
  }()

  let rightDetailLabel: UILabel = {
    let lbl = UILabel()
    lbl.font = Styles.SettingsCell.rightDetailFont
    lbl.textColor = Styles.SettingsCell.rightDetailColor
    lbl.translatesAutoresizingMaskIntoConstraints = false
    return lbl
  }()

  let rightArrow = UIImageView(image: UIImage(named: "map-detail-arrow"))

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

  func configure(rightDetailText: String? = nil) {
    if let text = rightDetailText {
      rightArrow.isHidden = true
      rightDetailLabel.text = text
    } else {
      rightDetailLabel.isHidden = true
    }
  }

  fileprivate func initialize() {

    backgroundColor = .clear

    rightArrow.translatesAutoresizingMaskIntoConstraints = false
    rightArrow.contentMode = .scaleAspectFit

    contentView.addSubview(rightArrow)
    contentView.addSubview(titleLabel)
    contentView.addSubview(subtitleLabel)
    contentView.addSubview(rightDetailLabel)

    titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
    subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true

    titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
    titleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true

    subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
    subtitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20).isActive = true

    rightArrow.centerYAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
    rightArrow.widthAnchor.constraint(equalToConstant: 25).isActive = true
    let arrowTrailingConstraint = rightArrow.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15)
    arrowTrailingConstraint.isActive = true

    rightDetailLabel.centerYAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
    rightDetailLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25).isActive = true

    titleLabel.trailingAnchor.constraint(equalTo: rightArrow.leadingAnchor, constant: -15).isActive = true
    subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true

  }
}

extension SettingsTableViewCell: Reusable { }
