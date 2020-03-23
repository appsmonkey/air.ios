//
//  AQITableViewCell.swift
//  CityOSAir
//
//  Created by Andrej Saric on 29/12/2016.
//  Copyright © 2016 CityOS. All rights reserved.
//

import UIKit

class AQITableViewCell: UITableViewCell {

  let colorView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.layer.cornerRadius = 3
    return view
  }()

  let grayView: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor.fromHex("f5f5f5")
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()

  let numberLabel: UILabel = {
    let lbl = UILabel()
    lbl.textAlignment = .center
    lbl.textColor = Styles.Colors.white
    lbl.font = UIFont.appRegularWithSize(10)
    lbl.translatesAutoresizingMaskIntoConstraints = false
    return lbl
  }()

  let notationLabel: UILabel = {
    let lbl = UILabel()
    lbl.textAlignment = .center
    lbl.textColor = Styles.Colors.white
    lbl.font = UIFont.appRegularWithSize(8)
    lbl.translatesAutoresizingMaskIntoConstraints = false
    return lbl
  }()

  let statusImageView: UIImageView = {
    let imgV = UIImageView()
    imgV.translatesAutoresizingMaskIntoConstraints = false
    imgV.contentMode = .scaleAspectFit
    return imgV
  }()

  let msgLabel: UILabel = {
    let lbl = UILabel()
    lbl.font = UIFont.appMediumWithSize(8)
    lbl.translatesAutoresizingMaskIntoConstraints = false
    lbl.numberOfLines = 0
    return lbl
  }()

  let bigTextLabel: UILabel = {
    let lbl = UILabel()
    lbl.numberOfLines = 0
    lbl.font = UIFont.appRegularWithSize(8)
    lbl.textColor = UIColor.lightGray
    lbl.translatesAutoresizingMaskIntoConstraints = false
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

    // Configure the view for the selected state
  }

  func configure(aqi: AQI, type: AQIType) {
    colorView.backgroundColor = aqi.color
    numberLabel.text = type == .pm10 ? aqi.valuesPM10 : aqi.valuesPM25
    notationLabel.text = aqi.notation
    msgLabel.text = aqi.message
    msgLabel.textColor = aqi.textColor
    statusImageView.image = aqi.image


    bigTextLabel.text = aqi.text
  }

  fileprivate func initialize() {

    contentView.backgroundColor = .clear

    selectionStyle = .none

    contentView.addSubview(colorView)
    colorView.addSubview(numberLabel)
    colorView.addSubview(notationLabel)
    contentView.addSubview(grayView)
    grayView.addSubview(statusImageView)
    grayView.addSubview(msgLabel)
    contentView.addSubview(bigTextLabel)

    colorView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    grayView.heightAnchor.constraint(equalTo: colorView.heightAnchor).isActive = true

    colorView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
    colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true

    grayView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
    grayView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true

    colorView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3, constant: 1).isActive = true
    grayView.leadingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: 2).isActive = true

    bigTextLabel.leadingAnchor.constraint(equalTo: colorView.leadingAnchor).isActive = true
    bigTextLabel.trailingAnchor.constraint(equalTo: grayView.trailingAnchor).isActive = true
    bigTextLabel.topAnchor.constraint(equalTo: colorView.bottomAnchor, constant: 10).isActive = true
    bigTextLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15).isActive = true

    numberLabel.centerXAnchor.constraint(equalTo: colorView.centerXAnchor).isActive = true
    numberLabel.bottomAnchor.constraint(equalTo: colorView.centerYAnchor, constant: 2).isActive = true

    notationLabel.centerXAnchor.constraint(equalTo: colorView.centerXAnchor).isActive = true
    notationLabel.topAnchor.constraint(equalTo: colorView.centerYAnchor, constant: -2).isActive = true

    statusImageView.centerYAnchor.constraint(equalTo: grayView.centerYAnchor).isActive = true
    statusImageView.leadingAnchor.constraint(equalTo: grayView.leadingAnchor, constant: 15).isActive = true

    msgLabel.centerYAnchor.constraint(equalTo: grayView.centerYAnchor).isActive = true
    msgLabel.leadingAnchor.constraint(equalTo: statusImageView.trailingAnchor, constant: 15).isActive = true

  }

  override func layoutSubviews() {
    super.layoutSubviews()
    self.contentView.layoutSubviews()
    grayView.roundCorners(corners: [.bottomRight, .topRight], radius: 3)
  }

}

extension AQITableViewCell: Reusable { }
