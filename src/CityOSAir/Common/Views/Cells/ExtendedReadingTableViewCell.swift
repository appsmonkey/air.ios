//
//  ExtendedReadingTableViewCell.swift
//  CityOSAir
//
//  Created by Andrej Saric on 28/12/2016.
//  Copyright © 2016 CityOS. All rights reserved.
//

import UIKit

class ExtendedReadingTableViewCell: UITableViewCell {

  let typeImage: UIImageView = {
    let img = UIImageView()
    img.contentMode = .scaleAspectFit
    return img
  }()

  let identifierLabel: UILabel = {
    let lbl = UILabel()
    lbl.font = Styles.DataCell.IdentifierLabel.font
    lbl.textColor = Styles.DataCell.IdentifierLabel.tintColor
    return lbl
  }()

  let readingLabel: UILabel = {
    let lbl = UILabel()
    lbl.font = Styles.DataCell.ReadingLabel.numberFont
    lbl.textColor = Styles.DataCell.ReadingLabel.tintColor
    return lbl
  }()

  let notationLabel: UILabel = {
    let lbl = UILabel()
    lbl.font = Styles.DataCell.NotationLabel.identifierFont
    lbl.textColor = Styles.DataCell.NotationLabel.tintColor
    return lbl
  }()

  let flagLabel: UILabel = {
    let lbl = UILabel()
    lbl.font = Styles.DataCell.FlagLabel.font
    lbl.translatesAutoresizingMaskIntoConstraints = false
    return lbl
  }()

  let rightArrow: UIImageView = {
    let img = UIImageView(image: UIImage(named: "map-detail-arrow"))
    img.translatesAutoresizingMaskIntoConstraints = false
    return img
  }()

  var identifierYConstraint: NSLayoutConstraint!

  var rightConstraint: NSLayoutConstraint!

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

  func configure(_ readingType: ReadingType, aqi: AQI, value: String) {

    // if reading is pressure convert to hPa
    if readingType == .pressure {
      let pressure = (Int(value) ?? 0) / 100
      readingLabel.text = String(Int(pressure))
    } else {
      readingLabel.text = value
    }
    notationLabel.text = readingType.unitNotation

    flagLabel.text = aqi.message
    flagLabel.textColor = aqi.textColor
    readingLabel.textColor = aqi.textColor

    // if reading is pm type setup cell or pm values and attributed string
    if readingType == ReadingType.pm25 || readingType == ReadingType.pm10 {
      let attributed = NSMutableAttributedString(string: readingType.identifier,
                                                 attributes: [NSAttributedString.Key.font: Styles.DataCell.IdentifierLabel.font])
      attributed.setAttributes([NSAttributedString.Key.font: Styles.DataCell.IdentifierLabel.subscriptFont,
                                NSAttributedString.Key.baselineOffset: -5], range: NSRange(location: 2, length: readingType == .pm25 ? 3 : 2))

      identifierLabel.attributedText = attributed
      identifierYConstraint.constant = 0
      typeImage.image = aqi.image
      typeImage.contentMode = .scaleAspectFit
    } else {
      typeImage.image = UIImage(named: readingType.image)
      identifierLabel.text = readingType.identifier
      identifierYConstraint.constant = 0
    }
  }

  fileprivate func initialize() {

    backgroundColor = .clear

    contentView.addSubview(rightArrow)
    contentView.addSubview(typeImage)
    contentView.addSubview(identifierLabel)
    contentView.addSubview(readingLabel)
    contentView.addSubview(notationLabel)
    contentView.addSubview(flagLabel)

    contentView.addConstraintsWithFormat("H:|-15-[v0(30)]-15-[v1]", views: typeImage, identifierLabel)
    contentView.addConstraintsWithFormat("H:[v0][v1]-15-[v2]-25-|", views: readingLabel, notationLabel, rightArrow)

    contentView.addConstraint(NSLayoutConstraint(item: typeImage, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1, constant: -10))

    identifierYConstraint = NSLayoutConstraint(item: identifierLabel, attribute: .centerY, relatedBy: .equal, toItem: typeImage, attribute: .centerY, multiplier: 1, constant: 0)

    contentView.addConstraint(identifierYConstraint)

    contentView.addConstraint(NSLayoutConstraint(item: flagLabel, attribute: .top, relatedBy: .equal, toItem: identifierLabel, attribute: .bottom, multiplier: 1, constant: 0))

    contentView.addConstraint(NSLayoutConstraint(item: flagLabel, attribute: .leading, relatedBy: .equal, toItem: identifierLabel, attribute: .leading, multiplier: 1, constant: 0))

    contentView.addConstraint(NSLayoutConstraint(item: readingLabel, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1, constant: 0))

    contentView.addConstraint(NSLayoutConstraint(item: notationLabel, attribute: .lastBaseline, relatedBy: .equal, toItem: readingLabel, attribute: .lastBaseline, multiplier: 1, constant: 0))

    contentView.addConstraint(NSLayoutConstraint(item: rightArrow, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1, constant: 0))

    rightArrow.contentMode = .scaleAspectFit

    rightArrow.heightAnchor.constraint(equalToConstant: 18).isActive = true
    rightArrow.widthAnchor.constraint(equalToConstant: 18).isActive = true

    rightConstraint = notationLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -25)
    rightConstraint.isActive = false

//        rightArrow.topAnchor.constraint(equalTo: notationLabel.topAnchor, constant: 0).isActive = true
//        rightArrow.bottomAnchor.constraint(equalTo: notationLabel.bottomAnchor, constant: 0).isActive = true

//        contentView.addConstraint(NSLayoutConstraint(item: rightArrow, attribute: .top, relatedBy: .equal, toItem: notationLabel, attribute: .top, multiplier: 1, constant: 0))
//        contentView.addConstraint(NSLayoutConstraint(item: rightArrow, attribute: .bottom, relatedBy: .equal, toItem: notationLabel, attribute: .bottom, multiplier: 1, constant: 0))

  }
}

extension ExtendedReadingTableViewCell: Reusable { }
