//
//  ChartView.swift
//  CityOSAir
//
//  Created by Andrej Saric on 29/08/16.
//  Copyright © 2016 CityOS. All rights reserved.
//

//
//  ChartView.swift
//  CityOSAir
//
//  Created by Andrej Saric on 29/08/16.
//  Copyright © 2016 CityOS. All rights reserved.
//

import UIKit
import Charts

class ChartView: UIView {

  let pm25xValue: [Double] = [0, 12, 35.5, 55.5, 150.5, 250.5, 250.6]
  let pm10xValue: [Double] = [0, 54, 154, 254, 354, 424, 425]
  var xCounter = 0

  lazy var chartView: LineChartView = {

    let chart = LineChartView()
    chart.gridBackgroundColor = .clear

    chart.leftAxis.enabled = true
    chart.rightAxis.enabled = true//false
    chart.legend.enabled = false

    chart.xAxis.labelPosition = .bottom
    chart.xAxis.labelRotationAngle = 0
    chart.xAxis.drawAxisLineEnabled = false
    chart.leftAxis.drawAxisLineEnabled = false
    chart.xAxis.drawGridLinesEnabled = false
    chart.leftAxis.drawGridLinesEnabled = true//false
    chart.rightAxis.drawAxisLineEnabled = false

    chart.xAxis.setLabelCount(4, force: true)
    chart.xAxis.avoidFirstLastClippingEnabled = true

    chart.xAxis.labelFont = Styles.Graph.GraphLabels.font
    chart.xAxis.labelTextColor = Styles.Graph.GraphLabels.tintColor

    chart.leftAxis.labelFont = Styles.Graph.GraphLabels.font
    chart.leftAxis.labelTextColor = Styles.Graph.GraphLabels.tintColor

    chart.rightAxis.labelFont = Styles.Graph.GraphLabels.font
    chart.rightAxis.labelTextColor = Styles.Graph.GraphLabels.textColor

    chart.rightAxis.gridLineWidth = 1
    chart.rightAxis.gridColor = Styles.Graph.GraphLabels.lineColor

    chart.extraTopOffset = 50//100

    chart.scaleYEnabled = false
    chart.scaleXEnabled = false
    chart.pinchZoomEnabled = false
    chart.doubleTapToZoomEnabled = false
    chart.highlightPerTapEnabled = true
    chart.highlightPerDragEnabled = true

    chart.noDataText = "Fetching data . . ."
    chart.noDataTextColor = Styles.Graph.HeaderText.tintColor
    chart.chartDescription?.text = ""
    chart.isUserInteractionEnabled = true

    chart.rightAxis.labelPosition = .insideChart

    chart.rightAxis.xOffset = 10
    chart.rightAxis.yOffset = -20

    chart.marker = BalloonMarker(color: .white, font: UIFont.systemFont(ofSize: 12), textColor: .black, insets: UIEdgeInsets(top: 10, left: 10, bottom: 20, right: 10))

    chart.delegate = self

    return chart
  }()

  lazy var numberFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.roundingMode = .floor
    formatter.maximumFractionDigits = 0
    formatter.minimumFractionDigits = 0
    return formatter
  }()

  fileprivate var timestamps = [String]()

  var notation: String!

  func setupConstraints() {
    self.addSubview(chartView)

    self.addConstraintsWithFormat("H:|[v0]|", views: chartView)
    self.addConstraintsWithFormat("V:|[v0]|", views: chartView)
  }

  func updateChart(chartPoints: [ChartPoint]) {

    let dataPoints = chartPoints.map { $0.xLabel }
    let values = chartPoints.map { $0.value }

    for i in 0..<dataPoints.count {
      chartView.data?.addEntry(ChartDataEntry(x: Double(i), y: values[i]), dataSetIndex: 0)
    }

    chartView.setVisibleXRange(minXRange: chartView.data!.xMin, maxXRange: chartView.data!.xMax)
    chartView.notifyDataSetChanged()
    chartView.moveViewToX(values.last!)
  }

  func clear() {
    timestamps = []
    xCounter = 0
    chartView.data = nil
    chartView.noDataText = "Fetching data . . ."
    chartView.notifyDataSetChanged()
    chartView.setNeedsDisplay()
  }

  func setChart(chartPoints: [ChartPoint]?, readingType: ReadingType, timeframe: ReadingPeriod) {

    guard var chartPoints = chartPoints else {
      chartView.noDataText = "Unable to retrieve data."
      chartView.notifyDataSetChanged()
      return
    }

    if chartPoints.count == 0 {
      chartView.noDataText = "No data to show."
      chartView.notifyDataSetChanged()
      return
    }

    if chartPoints.count == 1 {
      if let chartPoint = chartPoints.first {
        let point = ChartPoint(chartPoint: chartPoint)
        chartPoints.append(point)
      }
    }

    var dataPoints = chartPoints.map { $0.xLabel }
    var values = chartPoints.map { $0.value }
    if readingType == .pressure {
      values = values.map {
        return $0 / 100
      }
    }

    timestamps = dataPoints

    if timeframe == .week || timeframe == .month {
      dataPoints = dataPoints.map({ timestamp -> String in
        if timestamp.count < 6 { return "" }
        let index = timestamp.index(timestamp.endIndex, offsetBy: -6)
        let _timestamp = String(timestamp[..<index])
        return _timestamp
      })
    } else if timeframe == .day {
      dataPoints = dataPoints.map({ timestamp -> String in
        if timestamp.count < 6 { return "" }
        let index = timestamp.index(timestamp.endIndex, offsetBy: -6)
        return String(timestamp[index...])

      })
    } else {
      dataPoints = chartPoints.map({ point -> String in
        var minute = ""
        if point.date != nil {
          let elapsed = Date().timeIntervalSince(point.date!)
          let minutes = Int(elapsed / 60)
          minute = String(minutes)
        }
        return minute + "m"
      })
    }

    let chartFormatter = ChartFormatter()
    chartFormatter.timestamps = dataPoints
    chartView.xAxis.valueFormatter = chartFormatter

    var dataEntries: [ChartDataEntry] = []

    for i in 0..<dataPoints.count {
      let dataEntry = ChartDataEntry(x: Double(i), y: values[i])
      dataEntries.append(dataEntry)
    }

    let lineChartDataSet = LineChartDataSet(entries: dataEntries, label: "Values")

    lineChartDataSet.mode = .cubicBezier
    lineChartDataSet.lineWidth = 0
    lineChartDataSet.circleRadius = 0
    lineChartDataSet.drawValuesEnabled = false

    lineChartDataSet.highlightColor = .white

    lineChartDataSet.drawVerticalHighlightIndicatorEnabled = true
    lineChartDataSet.drawHorizontalHighlightIndicatorEnabled = false

    var gradientColors = Styles.GraphColors.defaultGradientColors as CFArray

    var colorLocations: [CGFloat] = Styles.GraphColors.defaultGradientLocations

    if readingType == .pm25 || readingType == .pm10 {
      let max = lineChartDataSet.yMax + (lineChartDataSet.yMax * 0.1)
      let numberOfGradientsToLeave = setupLabelsFor(min: 0, max: max, readingType: readingType)
      //remove from the beginning to get to numberOfGradientsToLeave
      if max < 13 {
        gradientColors = Array(Styles.GraphColors.pmGreatGradientColors) as CFArray
      } else {
        gradientColors = Array(Styles.GraphColors.pmGradientColors.dropFirst(7 - numberOfGradientsToLeave)) as CFArray
      }

      let incremental: CGFloat = 1.0 / CGFloat(numberOfGradientsToLeave - 1)

      colorLocations = [0.0]

      for num in 1..<numberOfGradientsToLeave {
        colorLocations.append(incremental * CGFloat(num))
      }

      colorLocations = colorLocations.reversed()
      
      if readingType == .pm25 {
        if lineChartDataSet.yMax > 251 {
          chartView.setVisibleYRangeMaximum(251, axis: .left)
        }
      } else {
        if lineChartDataSet.yMax > 425 {
          chartView.setVisibleYRangeMaximum(425, axis: .left)
        }
      }
    } else {
      chartView.leftAxis.setLabelCount(4, force: true)
      let min = lineChartDataSet.yMin
      chartView.leftAxis.axisMinimum = min == 0.0 ? min - 2 : min - (min * 0.1)
      if notation == ReadingType.batteryVoltage.unitNotation {
        chartView.leftAxis.axisMaximum = 110
        numberFormatter.maximumFractionDigits = 2
      } else {
        numberFormatter.maximumFractionDigits = 0
      }
      chartView.leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: numberFormatter)
      chartView.rightAxis.enabled = false
    }

    if let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) {
      lineChartDataSet.fill = Fill.fillWithLinearGradient(gradient, angle: 90.0)
    }

    lineChartDataSet.fillAlpha = 0.66
    lineChartDataSet.drawFilledEnabled = true
    let lineChartData = LineChartData(dataSet: lineChartDataSet)

    chartView.data = lineChartData
    if lineChartData.entryCount > 10 {
      let xScale = lineChartData.entryCount / 10
      chartView.zoom(scaleX: CGFloat(xScale), scaleY: 0.8, x: 0.0, y: 0.0)
      chartView.moveViewToX(Double(lineChartData.entryCount))
    }

    chartView.xAxis.granularity = 1.0
    chartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
  }

  private func setupLabelsFor(min: Double = 0, max: Double, readingType: ReadingType) -> Int {
    let xValues = readingType == .pm10 ? pm10xValue : pm25xValue
    var xMax = 0.0

    for num in xValues {
      if num > max && xMax < max {
        xMax = num
      }
    }

    if xMax == 0.0 {
      xMax = max
    }

    let filteredX = xValues.filter { $0 >= min && $0 <= xMax }
    let numberOfLabels = filteredX.count

    chartView.leftAxis.axisMinimum = min
    chartView.leftAxis.axisMaximum = max
    chartView.rightAxis.axisMinimum = min
    chartView.rightAxis.axisMaximum = max

    chartView.rightAxis.valueFormatter = DefaultAxisValueFormatter(block: { value, axisBase -> String in

      if self.xCounter >= numberOfLabels {
        self.xCounter = 0
      }

      let num = filteredX[self.xCounter]

      self.xCounter += 1

      if num == filteredX.last {
        return ""
      }

      if readingType == .pm10 {
        switch num {
        case 0:
          return "Great"
        case 54:
          return "OK"
        case 154:
          return "Sensitive beware"
        case 254:
          return "Unhealthy"
        case 354:
          return "Very Unhealthy"
        case 424:
          return "Hazardous"
        default:
          return "Hazardous"
        }
      } else {
        switch num {
        case 0:
          return "Great"
        case 12:
          return "OK"
        case 35.5:
          return "Sensitive beware"
        case 55.5:
          return "Unhealthy"
        case 150.5:
          return "Very Unhealthy"
        case 250.5:
          return "Hazardous"
        default:
          return "Hazardous"
        }
      }
    })

    chartView.leftAxis.setLabelCount(numberOfLabels, force: true)
    chartView.rightAxis.setLabelCount(numberOfLabels, force: true)

    return numberOfLabels
  }

  func commonInit() {
    self.setupConstraints()
  }

  init(notation: String) {
    super.init(frame: CGRect.zero)
    commonInit()
    self.notation = notation
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }
}

extension ChartView: ChartViewDelegate {
  func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {

    let timestamp = timestamps[Int(entry.x)]

    let value = notation == ReadingType.temperature.unitNotation ? "\(entry.y.roundTo(places: 1))" : "\(Int(entry.y))"

    if let marker = chartView.marker as? BalloonMarker {
      marker.setLabel(timestamp, value: value, notation: notation)
    }

  }
}

class ChartFormatter: NSObject, IAxisValueFormatter {

  var timestamps = [String]()

  func stringForValue(_ value: Double, axis: AxisBase?) -> String {

    let value = abs(Int(value))

    if value >= timestamps.count {
      return timestamps.last ?? ""
    }
    return timestamps[value]
  }
}
