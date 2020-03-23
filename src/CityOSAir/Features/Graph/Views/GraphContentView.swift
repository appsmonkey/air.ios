//
//  GraphContentView.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 12/22/19.
//  Copyright © 2019 CityOS. All rights reserved.
//

import UIKit
import SnapKit
import Charts

class GraphContentView: UIView {
  let closeButton = UIButton().autolayoutView()
  let closeButtonTop = UIButton().autolayoutView()
  let headerLabel = UILabel().autolayoutView()
  let stateLabel = PaddedLabel().autolayoutView()
  let readingLabel = UILabel().autolayoutView()
  let notationLabel = UILabel().autolayoutView()
  let stackView = UIStackView().autolayoutView()
  var reading: AirReading!
  var chartView: ChartView!

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension GraphContentView {
  func setupViews() {
    backgroundColor = .white

    setupCloseButton()
    setupHeaderLabel()
    setupReadingLabel()
    setupStateLabel()
    setupNotationLabel()
    // setupStackView()
    // setupChartView()
  }

  func setupCloseButton() {
    addSubview(closeButton)

    closeButton.setImage(UIImage(named: "close"), for: UIControl.State())

    closeButton.snp.makeConstraints {
      $0.top.equalTo(safeAreaLayoutGuide.snp.top)
      $0.height.equalTo(45)
      $0.width.equalTo(45)
      $0.right.equalTo(-15)
    }
  }

  func setupHeaderLabel() {
    addSubview(headerLabel)

    headerLabel.font = Styles.Graph.HeaderText.font
    headerLabel.textColor = Styles.Graph.HeaderText.tintColor
    headerLabel.text = Text.Readings.title
    headerLabel.textAlignment = .center

    headerLabel.snp.makeConstraints {
      $0.centerX.equalTo(self)
      $0.top.equalTo(closeButton.snp.centerY)
    }
  }

  func setupReadingLabel() {
    addSubview(readingLabel)

    readingLabel.font = Styles.Graph.ReadingLabel.font
    readingLabel.textColor = Styles.Graph.ReadingLabel.tintColor
    readingLabel.textAlignment = .center
    readingLabel.adjustsFontSizeToFitWidth = true

    readingLabel.snp.makeConstraints {
      $0.top.equalTo(headerLabel.snp.bottom)
      $0.centerX.equalTo(self.snp.centerX)
    }
  }

  func setupStateLabel() {
    addSubview(stateLabel)

    stateLabel.textAlignment = .center
    stateLabel.backgroundColor = UIColor.fromHex("f5f5f5")
    stateLabel.font = Styles.Graph.StateLabel.font
    stateLabel.layer.cornerRadius = 3
    stateLabel.layer.masksToBounds = true
    stateLabel.isHidden = true

    stateLabel.snp.makeConstraints {
      $0.top.equalTo(readingLabel.snp.bottom)
      $0.centerX.equalTo(self.snp.centerX)
      $0.width.greaterThanOrEqualTo(100)
    }
  }

  func setupNotationLabel() {
    addSubview(notationLabel)

    notationLabel.font = Styles.Graph.ReadingLabel.subscriptFont
    notationLabel.textColor = Styles.Graph.ReadingLabel.subscriptColor
    notationLabel.textAlignment = .left
    notationLabel.adjustsFontSizeToFitWidth = true
    notationLabel.translatesAutoresizingMaskIntoConstraints = false

    notationLabel.snp.makeConstraints {
      $0.leading.equalTo(readingLabel.snp.trailing)
      $0.lastBaseline.equalTo(readingLabel.snp.lastBaseline)
    }
  }

  func setupStackView() {
    addSubview(stackView)

    stackView.axis = NSLayoutConstraint.Axis.horizontal
    stackView.alignment = .fill
    stackView.distribution = .fillEqually
    stackView.spacing = 10

    for num in 0...3 {
      let button = UIButton()
      button.tag = num

      button.backgroundColor = UIColor.clear
      button.setTitleColor(UIColor.fromHex("ababab"), for: .normal)
      button.titleLabel?.font = UIFont.appRegularWithSize(7.5)
      button.layer.cornerRadius = 3

      switch num {
      case 0:
        button.setTitle("Live", for: .normal)
        button.backgroundColor = UIColor.fromHex("f5f5f5")
      case 1:
        button.setTitle("Day", for: .normal)
      case 2:
        button.setTitle("Week", for: .normal)
      case 3:
        button.setTitle("Month", for: .normal)
      default:
        break
      }

      stackView.addArrangedSubview(button)

      stackView.snp.makeConstraints {
        $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        $0.height.equalTo(35)
        $0.leading.equalTo(10)
        $0.trailing.equalTo(10)
      }
    }
  }

  func setupChartView() {
    chartView = ChartView(notation: "\(reading.readingType.unitNotation)").autolayoutView()
    addSubview(chartView)

    chartView.snp.makeConstraints {
      $0.leading.equalTo(snp.leading)
      $0.trailing.equalTo(snp.trailing)
      $0.top.equalTo(stateLabel.snp.bottom).offset(-5)
      $0.bottom.equalTo(layoutMarginsGuide.snp.bottom).offset(-25)
    }

    setupCloseButtonTop()
  }

  func addChartView() {
    chartView.removeFromSuperview()
    chartView = ChartView(notation: "\(reading.readingType.unitNotation)")

    chartView.translatesAutoresizingMaskIntoConstraints = false

    addSubview(chartView)

    chartView.snp.makeConstraints {
      $0.top.equalTo(stateLabel.snp.bottom).offset(-5)
      $0.bottom.equalTo(stackView.snp.top).offset(-25)
      $0.leading.equalTo(snp.leading)
      $0.trailing.equalTo(snp.trailing)
    }

    setNeedsLayout()
  }

  func setupCloseButtonTop() {
    addSubview(closeButtonTop)

    closeButtonTop.setImage(UIImage(named: "close"), for: UIControl.State())

    closeButtonTop.snp.makeConstraints {
      $0.top.equalTo(safeAreaLayoutGuide.snp.top)
      $0.height.equalTo(45)
      $0.width.equalTo(45)
      $0.right.equalTo(-15)
    }
  }
  
  func setupReadings() {
    let readingType = reading.readingType
    if readingType == .unidentified {
      headerLabel.text = String(reading.type.split(separator: "|")[0])
      if reading.type.split(separator: "|").count > 1 {
        notationLabel.text = String(reading.type.split(separator: "|")[1])
      }
    } else {
      headerLabel.text = readingType.identifier
      notationLabel.text = readingType.unitNotation
    }
    
    if reading.readingType == .pm25 || reading.readingType == .pm10 {
      let aqiType = reading.readingType == .pm25 ? AQIType.pm25 : AQIType.pm10
      let aqi = AQI.getAQIForTypeWithValue(value: reading.value.roundTo(places: 1), aqiType: aqiType)
      
      stateLabel.text = aqi.message
      stateLabel.textColor = aqi.textColor
      stateLabel.isHidden = false
      
      let attributed = NSMutableAttributedString(string: readingType.identifier,
                                                 attributes: [NSAttributedString.Key.font: Styles.Graph.HeaderText.font])
      attributed.setAttributes([NSAttributedString.Key.font: Styles.Graph.HeaderText.subscriptFont, NSAttributedString.Key.baselineOffset: -5],
                               range: NSRange(location: 2, length: readingType == .pm25 ? 3 : 2))
      
      headerLabel.attributedText = attributed
    }
    
    if reading.readingType == .batteryVoltage {
      readingLabel.text = "\(reading.value)"
    } else if reading.readingType == .pressure {
      let pressure = Int(round(reading.value)) / 100
      readingLabel.text = "\(pressure)"
    } else {
      readingLabel.text = "\(Int(round(reading.value)))"
    }
  }
}
