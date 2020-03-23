//
//  InputTableViewCell.swift
//  CityOSAir
//
//  Created by Andrej Saric on 28/08/16.
//  Copyright © 2016 CityOS. All rights reserved.
//

import UIKit

class InputTableViewCell: UITableViewCell {

  let textField: UITextField = {
    let txtField = UnderlineTextField()

    txtField.font = Styles.FormCell.font
    txtField.textColor = Styles.FormCell.inputColor
    txtField.borderStyle = .none
    txtField.backgroundColor = .clear

    let spacerView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 10))
    txtField.leftViewMode = UITextField.ViewMode.always
    txtField.leftView = spacerView

    return txtField
  }()

  var placeholder: String? {
    didSet {
      guard let hint = placeholder else {
        return
      }

      let str = NSAttributedString(string: hint, attributes: [NSAttributedString.Key.foregroundColor: Styles.FormCell.placeholderColor])
      textField.attributedPlaceholder = str
    }
  }

  private var dateDelegate: DateDelegate?

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

    contentView.addSubview(textField)

    contentView.addConstraintsWithFormat("V:|[v0]|", views: textField)
    contentView.addConstraintsWithFormat("H:|[v0]|", views: textField)
  }

  func configure(placeholder: String, tag: Int, target: Any?, action: Selector, isSecure: Bool = false) -> InputTableViewCell {
    self.placeholder = placeholder
    self.textField.tag = tag
    self.textField.autocapitalizationType = .none
    self.textField.isSecureTextEntry = isSecure
    self.textField.addTarget(target, action: action, for: .editingChanged)
    if let delegate = target as? UITextFieldDelegate {
      self.textField.delegate = delegate
    }
    return self
  }

  func configure(placeholder: String, tag: Int, withDatePickerMode: UIDatePicker.Mode, delegate: DateDelegate?) -> InputTableViewCell {
    let datePicker = UIDatePicker()
    datePicker.datePickerMode = withDatePickerMode
    datePicker.addTarget(self, action: #selector(InputTableViewCell.dateSelected(sender:)), for: .valueChanged)
    textField.inputView = datePicker
    textField.placeholder = placeholder
    self.dateDelegate = delegate
    return self
  }
}

extension InputTableViewCell {
  @objc func dateSelected(sender: UIDatePicker) {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = DateFormatter.Style.medium
    dateFormatter.timeStyle = DateFormatter.Style.none
    textField.text = dateFormatter.string(from: sender.date)

    if let delegate = dateDelegate {
      delegate.onDateSelected(sender.date)
    }
  }
}

protocol DateDelegate {
  func onDateSelected(_ date: Date)
}

extension InputTableViewCell: Reusable { }

