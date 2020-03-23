//
//  VerifyEmailContentView.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 12/1/19.
//  Copyright © 2019 CityOS. All rights reserved.
//

import UIKit
import SnapKit

class VerifyEmailContentView: UIView {
  let messageTextView = UITextView.autolayoutView()
  var email = " "

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension VerifyEmailContentView {
  func setupViews() {
    setupMessageTextView()
  }

  func setupMessageTextView() {
    addSubview(messageTextView)
    
    backgroundColor = .white
    
    messageTextView.backgroundColor = .white
    messageTextView.isEditable = false
    
    messageTextView.snp.makeConstraints {
      $0.edges.left.equalTo(20)
      $0.edges.right.equalTo(20)
      $0.centerY.equalToSuperview()
    }
  }
  
  func setupEmail() {
    let veifyEmailText = "We sent you an email at:\n\(email)\n\nPlease click activation link in email to continue."
    messageTextView.attributedText = veifyEmailText
      .attributedString(attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18.0), NSAttributedString.Key.foregroundColor: UIColor.fromHex("9e9e9e")])
      .makeBold(string: email, fontSize: 20.0)
  }
}
