//
//  SocialLoginTableViewCell.swift
//  CityOSAir
//
//  Created by Haris Kovacevic on 03/06/2019.
//  Copyright © 2019 CityOS. All rights reserved.
//

import UIKit
import GoogleSignIn

class SocialLoginTableViewCell: UITableViewCell {
  let stackView: UIStackView = {
    let stackView = UIStackView();
    stackView.axis = .horizontal
    stackView.alignment = .fill
    stackView.spacing = 4.0
    stackView.distribution = .fillEqually
    stackView.translatesAutoresizingMaskIntoConstraints = true
    return stackView;
  }()

  let googleSignInButton: UIButton = {
    let button: UIButton = IconButton();
    button.setTitle("Google", for: .normal)
    button.backgroundColor = UIColor(red: 232 / 255, green: 101 / 255, blue: 97 / 255, alpha: 1.0)
    button.setImage(UIImage(named: "icon-google"), for: .normal)
    button.layer.cornerRadius = 5
    button.imageView?.contentScaleFactor = 0.5
    return button
  }()

  let facebookSignInButton: UIButton = {
    let button: UIButton = IconButton();
    button.setTitle("Facebook", for: .normal)
    button.backgroundColor = UIColor(red: 60 / 255, green: 90 / 255, blue: 153 / 255, alpha: 1.0)
    button.setImage(UIImage(named: "icon-facebook"), for: .normal)
    button.layer.cornerRadius = 5
    button.imageView?.contentScaleFactor = 0.5
    return button
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

  fileprivate func initialize() {
    stackView.addArrangedSubview(facebookSignInButton)
    stackView.addArrangedSubview(googleSignInButton)
    contentView.addSubview(stackView)
    selectionStyle = .none
    contentView.addConstraintsWithFormat("V:|[v0]|", views: stackView)
    contentView.addConstraintsWithFormat("H:|-20-[v0]-20-|", views: stackView)

  }
}


extension SocialLoginTableViewCell: Reusable {
}



