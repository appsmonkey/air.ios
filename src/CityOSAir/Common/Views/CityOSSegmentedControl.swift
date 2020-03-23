//
//  CityOSSegmentedControl.swift
//  CityOSAir
//
//  Created by Andrej Saric on 20/04/2017.
//  Copyright © 2017 CityOS. All rights reserved.
//

import UIKit

class CityOSSegmented: UIControl {

  var thumbView = UIView()

  var items: [CityOSSegment] = [] {
    didSet {
      setupLabels()
    }
  }

  var selectedIndex: Int = 0 {
    didSet {
      displayNewSelectedIndex()
    }
  }

  override init(frame: CGRect) {
    super.init(frame: frame)

    setupView()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupView()
  }

  func setupView() {

    layer.cornerRadius = 10
    clipsToBounds = true

    backgroundColor = UIColor.clear

    setupLabels()
    addIndividualItemConstraints(items: items, mainView: self, padding: 0)
    insertSubview(thumbView, at: 0)
  }

  func setupLabels() {

    //TODO: Remove Subviews

    for label in items {

      label.translatesAutoresizingMaskIntoConstraints = false
      label.state(isSelected: false)
      self.addSubview(label)
    }

    addIndividualItemConstraints(items: items, mainView: self, padding: 0)
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    displayNewSelectedIndex()

  }

  override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
    let location = touch.location(in: self)

    var calculatedIndex: Int?
    for (index, item) in items.enumerated() {
      if item.frame.contains(location) {
        calculatedIndex = index
      }
    }


    if let calculatedIndex = calculatedIndex, calculatedIndex != selectedIndex {
      selectedIndex = calculatedIndex
      sendActions(for: .valueChanged)
    }

    return false
  }

  func displayNewSelectedIndex() {

    for (_, item) in items.enumerated() {
      item.state(isSelected: false)
    }

    let label = items[selectedIndex]
    label.state(isSelected: true)
  }

  func addIndividualItemConstraints(items: [UIView], mainView: UIView, padding: CGFloat) {

    _ = mainView.constraints

    for (index, button) in items.enumerated() {

      let topConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: mainView, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1.0, constant: 0)

      let bottomConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: mainView, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: 0)

      var rightConstraint: NSLayoutConstraint!

      if index == items.count - 1 {

        rightConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutConstraint.Attribute.right, relatedBy: NSLayoutConstraint.Relation.equal, toItem: mainView, attribute: NSLayoutConstraint.Attribute.right, multiplier: 1.0, constant: -padding)

      } else {

        let nextButton = items[index + 1]
        rightConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutConstraint.Attribute.right, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nextButton, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1.0, constant: -padding)
      }


      var leftConstraint: NSLayoutConstraint!

      if index == 0 {

        leftConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: mainView, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1.0, constant: padding)

      } else {

        let prevButton = items[index - 1]
        leftConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: prevButton, attribute: NSLayoutConstraint.Attribute.right, multiplier: 1.0, constant: padding)

        let firstItem = items[0]

        let widthConstraint = NSLayoutConstraint(item: button, attribute: .width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: firstItem, attribute: .width, multiplier: 1.0, constant: 0)

        mainView.addConstraint(widthConstraint)
      }

      mainView.addConstraints([topConstraint, bottomConstraint, rightConstraint, leftConstraint])
    }
  }
}

class CityOSSegment: UIView {

  typealias Colors = (background: UIColor, text: UIColor)

  var image: UIImage!
  var title: String
  var selectedBackgroundColor: UIColor
  var selectedTextColor: UIColor
  var defaultBackgroundColor: UIColor
  var defaultTextColor: UIColor

  var imageView: UIImageView!
  var label: UILabel!

  init(title: String, image: UIImage = #imageLiteral(resourceName: "box-0"), defaultColors: Colors, selectedColors: Colors) {
    self.title = title
    self.image = image
    self.defaultBackgroundColor = defaultColors.background.withAlphaComponent(0.6)
    self.defaultTextColor = defaultColors.text
    self.selectedTextColor = selectedColors.text
    self.selectedBackgroundColor = selectedColors.background.withAlphaComponent(0.6)


    super.init(frame: CGRect.zero)
    setupView()

    state(isSelected: false)
  }

  func state(isSelected selected: Bool) {
    imageView.image = selected ? self.image : UIImage()
    backgroundColor = selected ? selectedBackgroundColor : defaultBackgroundColor
    label.textColor = selected ? selectedTextColor : defaultTextColor
  }

  func setupView() {

    isUserInteractionEnabled = false

    imageView = UIImageView()
    imageView.image = image
    imageView.contentMode = .scaleAspectFit
    addSubview(imageView)

    label = UILabel()
    label.adjustsFontSizeToFitWidth = true
    label.text = title
    label.font = UIFont.appRegularWithSize(6)
    addSubview(label)

    imageView.translatesAutoresizingMaskIntoConstraints = false
    label.translatesAutoresizingMaskIntoConstraints = false

    imageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 2).isActive = true
    label.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 2).isActive = true

    imageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

    self.heightAnchor.constraint(equalToConstant: 25).isActive = true
    imageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1).isActive = true
    imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 1.0).isActive = true

    label.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true

  }


  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
