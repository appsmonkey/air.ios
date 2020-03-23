//
//  TextTableViewCell.swift
//  CityOSAir
//
//  Created by Haris Kovacevic on 05/06/2019.
//  Copyright © 2019 CityOS. All rights reserved.
//


import UIKit

class TextTableViewCell: UITableViewCell {
  let textview: UITextView = {
    let textview = UITextView()
    textview.textContentType = UITextContentType(rawValue: "")
    return textview
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
    contentView.addSubview(textview)
    contentView.addConstraintsWithFormat("V:|[v0]|", views: textview)
    contentView.addConstraintsWithFormat("H:|-20-[v0]-20-|", views: textview)
  }

}

extension TextTableViewCell: Reusable {
}
