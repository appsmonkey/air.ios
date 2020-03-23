//
//  MapInfoView.swift
//  CityOSAir
//
//  Created by Andrej Saric on 17/04/2017.
//  Copyright © 2017 CityOS. All rights reserved.
//

import UIKit

protocol MapInfoViewTappable: class {
  func didClickOnView(with name: String)
}

enum Stack {
  case pm25Stack
  case pm10Stack
  case tempStack
}

class MapInfoView: UIView {

  weak var delegate: MapInfoViewTappable?
  var infoViewHeight: CGFloat = 180
  var deviceId: String = ""

  let nameLabel: UILabel = {
    let lbl = UILabel()
    lbl.font = Styles.MapPopup.NameLabel.font
    lbl.textColor = Styles.MapPopup.NameLabel.tintColor
    lbl.textAlignment = .center
    lbl.translatesAutoresizingMaskIntoConstraints = false
    return lbl
  }()

  let messageLabel: UILabel = {
    let lbl = UILabel()
    lbl.font = Styles.MapPopup.MessageLabel.font
    lbl.textColor = Styles.MapPopup.NameLabel.tintColor
    lbl.textAlignment = .center
    lbl.translatesAutoresizingMaskIntoConstraints = false
    return lbl
  }()

  let identifierLabel1: UILabel = {
    let lbl = UILabel()
    lbl.font = Styles.MapPopup.IdentifierLabel.font
    lbl.textColor = Styles.MapPopup.IdentifierLabel.tintColor
    lbl.textAlignment = .center
    lbl.translatesAutoresizingMaskIntoConstraints = false
    return lbl
  }()

  let numberLabel1: UILabel = {
    let lbl = UILabel()
    lbl.font = Styles.MapPopup.NumberLabel.font
    lbl.translatesAutoresizingMaskIntoConstraints = false
    lbl.textAlignment = .center
    return lbl
  }()

  let notationLabel1: UILabel = {
    let lbl = UILabel()
    lbl.font = Styles.MapPopup.NotationLabel.font
    lbl.textColor = Styles.MapPopup.NotationLabel.tintColor
    lbl.textAlignment = .left
    lbl.translatesAutoresizingMaskIntoConstraints = false
    return lbl
  }()

  let identifierLabel2: UILabel = {
    let lbl = UILabel()
    lbl.font = Styles.MapPopup.IdentifierLabel.font
    lbl.textColor = Styles.MapPopup.IdentifierLabel.tintColor
    lbl.textAlignment = .center
    lbl.translatesAutoresizingMaskIntoConstraints = false
    return lbl
  }()

  let numberLabel2: UILabel = {
    let lbl = UILabel()
    lbl.font = Styles.MapPopup.NumberLabel.font
    lbl.translatesAutoresizingMaskIntoConstraints = false
    lbl.textAlignment = .center
    return lbl
  }()

  let notationLabel3: UILabel = {
    let lbl = UILabel()
    lbl.font = Styles.MapPopup.NotationLabel.font
    lbl.textColor = Styles.MapPopup.NotationLabel.tintColor
    lbl.textAlignment = .left
    lbl.translatesAutoresizingMaskIntoConstraints = false
    return lbl
  }()

  let identifierLabel3: UILabel = {
    let lbl = UILabel()
    lbl.font = Styles.MapPopup.IdentifierLabel.font
    lbl.textColor = Styles.MapPopup.IdentifierLabel.tintColor
    lbl.textAlignment = .center
    lbl.translatesAutoresizingMaskIntoConstraints = false
    return lbl
  }()

  let numberLabel3: UILabel = {
    let lbl = UILabel()
    lbl.font = Styles.MapPopup.NumberLabel.font
    lbl.translatesAutoresizingMaskIntoConstraints = false
    lbl.textAlignment = .center
    return lbl
  }()

  let notationLabel2: UILabel = {
    let lbl = UILabel()
    lbl.font = Styles.MapPopup.NotationLabel.font
    lbl.textColor = Styles.MapPopup.NotationLabel.tintColor
    lbl.textAlignment = .left
    lbl.translatesAutoresizingMaskIntoConstraints = false
    return lbl
  }()

  let rightArrow: UIImageView = {
    let img = UIImageView(image: UIImage(named: "map-detail-arrow"))
    img.translatesAutoresizingMaskIntoConstraints = false
    return img
  }()


  var bottomConstraint: NSLayoutConstraint!
  var heightConstraint: NSLayoutConstraint!
  var thirdStack: UIStackView!

  func setupView() {
    backgroundColor = .white
    let firstStack = createStack(stack: .pm25Stack)
    let secondStack = createStack(stack: .pm10Stack)
    thirdStack = createStack(stack: .tempStack)

    let hStack = UIStackView(arrangedSubviews: [firstStack, secondStack, thirdStack])
    hStack.axis = .horizontal
    hStack.distribution = .fillEqually
    hStack.spacing = 50

    let vStack = UIStackView(arrangedSubviews: [nameLabel, messageLabel, hStack])
    vStack.alignment = .center
    vStack.axis = .vertical
    vStack.distribution = .fill //Use Without constraints
    vStack.spacing = 5

    addSubview(vStack)

    vStack.translatesAutoresizingMaskIntoConstraints = false

    vStack.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
    vStack.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    vStack.topAnchor.constraint(equalTo: topAnchor, constant: 15).isActive = true

    guard let superview = superview else {
      return
    }

    heightConstraint = heightAnchor.constraint(equalToConstant: infoViewHeight)
    heightConstraint.isActive = true
    bottomConstraint = bottomAnchor.constraint(equalTo: superview.bottomAnchor)
    bottomConstraint.constant = infoViewHeight
    bottomConstraint.isActive = true
    leadingAnchor.constraint(equalTo: superview.leadingAnchor).isActive = true
    trailingAnchor.constraint(equalTo: superview.trailingAnchor).isActive = true

    //Add Arrow
    addSubview(rightArrow)
    rightArrow.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
    rightArrow.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
  }

  func createStack(stack: Stack) -> UIStackView {

    var identifierLbl: UILabel!
    var numLbl: UILabel!
    var notationLbl: UILabel!

    switch stack {
    case .pm25Stack:
      identifierLbl = identifierLabel1
      numLbl = numberLabel1
      notationLbl = notationLabel1
    case .pm10Stack:
      identifierLbl = identifierLabel2
      numLbl = numberLabel2
      notationLbl = notationLabel2
    case .tempStack:
      identifierLbl = identifierLabel3
      numLbl = numberLabel3
      notationLbl = notationLabel3
    }

    let hStack1 = UIStackView(arrangedSubviews: [numLbl, notationLbl])
    hStack1.axis = .horizontal
    hStack1.spacing = 4

    let vStack1 = UIStackView(arrangedSubviews: [identifierLbl, hStack1])
    vStack1.axis = .vertical
    vStack1.spacing = 0
    vStack1.alignment = .center

    return vStack1
  }

  func updateValues(title: String?, aqi: AQI, pm25Val: Double?, pm10Val: Double?, tempVal: Double?, isClickable: Bool = false, active: Bool?) {
    
    rightArrow.isHidden = !isClickable
    isUserInteractionEnabled = isClickable

    nameLabel.text = title ?? "Not defined"
    messageLabel.text = aqi.message
    if let active = active, active != true {
      messageLabel.text = "Device offline"
    }
    messageLabel.textColor = aqi.textColor

    var pm25Value = pm25Val
    var pm10Value = pm10Val
    var temperatureValue = tempVal
    if let active = active, active != true {
      pm25Value = -1
      pm10Value = -1
      temperatureValue = nil
    }    
    let pm25AQI = AQI.getAQIForTypeWithValue(value: pm25Value, aqiType: .pm25)
    let pm10AQI = AQI.getAQIForTypeWithValue(value: pm10Value, aqiType: .pm10)
    

    updateStack(stack: .pm25Stack, tintColor: pm25AQI.textColor, value: (pm25Value != nil && pm25Value != -1) ? pm25Val : 0)
    updateStack(stack: .pm10Stack, tintColor: pm10AQI.textColor, value: (pm10Value != nil && pm10Value != -1) ? pm10Val : 0)
    updateStack(stack: .tempStack, tintColor: .black, value: temperatureValue)
    
    
    layoutIfNeeded()

    if bottomConstraint.constant == 0 {
      return
    }

    self.bottomConstraint.constant = 0
    setNeedsUpdateConstraints()

    UIView.animate(withDuration: 0.5, animations: {
      guard let superView = self.superview else {
        self.layoutIfNeeded()
        return
      }

      superView.layoutIfNeeded()
    })
  }

  func hide() {
    layoutIfNeeded()
    if bottomConstraint.constant == infoViewHeight {
      return
    }

    self.bottomConstraint.constant = infoViewHeight
    setNeedsUpdateConstraints()
    UIView.animate(withDuration: 0.5, animations: {
      guard let superView = self.superview else {
        self.layoutIfNeeded()
        return
      }
      superView.layoutIfNeeded()
    })
  }

  func updateStack(stack: Stack, tintColor: UIColor, value: Double?) {
    var identifierLbl: UILabel!
    var numLbl: UILabel!
    var notationLbl: UILabel!

    let attributed: NSMutableAttributedString!

    switch stack {
    case .pm25Stack:
      identifierLbl = identifierLabel1
      numLbl = numberLabel1
      notationLbl = notationLabel1
      attributed = NSMutableAttributedString(string: ReadingType.pm25.identifier, attributes: [NSAttributedString.Key.font: Styles.MapPopup.IdentifierLabel.font])
      attributed.setAttributes([NSAttributedString.Key.font: Styles.MapPopup.IdentifierLabel.subscriptFont, NSAttributedString.Key.baselineOffset: -5], range: NSRange(location: 2, length: stack == .pm25Stack ? 3 : 2))
      identifierLbl.attributedText = attributed
    case .pm10Stack:
      identifierLbl = identifierLabel2
      numLbl = numberLabel2
      notationLbl = notationLabel2
      attributed = NSMutableAttributedString(string: ReadingType.pm10.identifier, attributes: [NSAttributedString.Key.font: Styles.MapPopup.IdentifierLabel.font])
      attributed.setAttributes([NSAttributedString.Key.font: Styles.MapPopup.IdentifierLabel.subscriptFont, NSAttributedString.Key.baselineOffset: -5], range: NSRange(location: 2, length: stack == .pm25Stack ? 3 : 2))
      identifierLbl.attributedText = attributed
    case .tempStack:
      identifierLbl = identifierLabel3
      numLbl = numberLabel3
      notationLbl = notationLabel3
      identifierLbl.text = "Temp"//ReadingType.temperature.identifier
      thirdStack.isHidden = value == nil
    }

    numLbl.text = "\(Int(round(value ?? 0)))"
    numLbl.textColor = tintColor

    notationLbl.text = stack == .tempStack ? ReadingType.temperature.unitNotation : AQI.zero.notation

  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    delegate?.didClickOnView(with: nameLabel.text ?? "")
  }
}
