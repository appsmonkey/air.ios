//
//  AQIViewController.swift
//  CityOSAir
//
//  Created by Andrej Saric on 29/12/2016.
//  Copyright © 2016 CityOS. All rights reserved.
//

import UIKit
import SnapKit

class AQIViewController: UIViewController {

  var aqiType: AQIType = AQIType.pm10
  let aqis = [AQI.great, AQI.ok, AQI.sensitive, AQI.unhealthy, AQI.veryUnhealthy, AQI.hazardous]
  lazy var aqiContentView = AQIContentView.autolayoutView()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupViews()

    if aqiType == .pm10 {
      aqiContentView.setPM10()
    } else {
      aqiContentView.setPM25()
    }
    
  }

  func setupViews() {
    view.addSubview(aqiContentView)
    
    aqiContentView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    aqiContentView.backButton.addTarget(self, action: #selector(AQIViewController.dimissViewController), for: .touchUpInside)
    aqiContentView.tableView.dataSource = self
    aqiContentView.tableView.delegate = self
  }

  @objc func dimissViewController() {
    self.dismiss(animated: true)
  }
}

extension AQIViewController: UITableViewDataSource, UITableViewDelegate {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return aqis.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! AQITableViewCell
    
    let aqi = aqis[indexPath.row]
    cell.configure(aqi: aqi, type: aqiType)
    
    return cell
  }

  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if (scrollView.contentOffset.y == 0) {
      aqiContentView.lineView.isHidden = true
    } else {
      aqiContentView.lineView.isHidden = false
    }
  }
  
}
