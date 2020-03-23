//
//  AlertsViewController.swift
//  CityOSAir
//
//  Created by Andrej Saric on 08/01/2017.
//  Copyright © 2017 CityOS. All rights reserved.
//

import UIKit
import AirshipKit
import SnapKit

class AlertsViewController: UIViewController {
  var shouldDisable = true
  var allTopics = TopicHandler.getAllTopics()
  var pushNotificationPreference: PushNotificationPreference?
  lazy var alertsContentView = AlertsContentView.autolayoutView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupViews()
    
    _configure()
  }
  
  private func setupViews() {
    view.addSubview(alertsContentView)
    
    alertsContentView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    alertsContentView.backButton.addTarget(self, action: #selector(dimissViewController), for: .touchUpInside)
    alertsContentView.tableView.dataSource = self
    alertsContentView.tableView.delegate = self
    alertsContentView.pmIndexSlider.delegate = self
  }
  
  private func _configure() {
    for preference in PushNotificationPreference.allCases {
      if preference.isSubscribed {
        alertsContentView.pmIndexSlider.selectedSection = preference.rawValue
      }
    }
    
  }
  
  @objc func dimissViewController() {
    self.navigationController?.popViewController(animated: true)
  }
}

extension AlertsViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 4
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as AlertTableViewCell
    
    pushNotificationPreference = PushNotificationPreference.init(rawValue: indexPath.row + 1)
    cell.titleLabel.text = pushNotificationPreference?.label
    
    if indexPath.row == 3 {
      cell.separatorInset = UIEdgeInsets.init(top: 0, left: cell.bounds.size.width, bottom: 0, right: 0);
    }
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 80
  }
}

enum PushNotificationPreference: Int, CaseIterable {
  case sensitive = 1
  case unhealthy = 2
  case veryUnhealthy = 3
  case hazardous = 4
  
  var label: String {
    switch self {
    case .sensitive:
      return "Unhealthy for sensitive"
    case .unhealthy:
      return "Unhealthy"
    case .veryUnhealthy:
      return "Very Unhealthy"
    case .hazardous:
      return "Hazardous"
    }
  }
  
  var tag: String {
    switch self {
    case .sensitive:
      return "setting_Sensitive"
    case .unhealthy:
      return "setting_Unhealthy"
    case .veryUnhealthy:
      return "setting_VeryUnhealthy"
    case .hazardous:
      return "setting_Hazardous"
    }
  }
  
  var isSubscribed: Bool {
    return UserDefaults.standard.integer(forKey: "selected_push_preference") == self.rawValue
  }
  
  static func getSelectedPreference () -> PushNotificationPreference? {
    let selection = UserDefaults.standard.integer(forKey: "selected_push_preference");
    
    if selection > 0 {
      return PushNotificationPreference(rawValue: selection)
    }
    
    return nil
  }
}

extension AlertsViewController: PmIndexAlertsSliderDelegate {
  func sectionChanged(slider: PmIndexAlertsSlider, selected: Int) {
    log.info("Section #\(selected)")
    guard selected != 0 else { return }
    UAirship.push()?.updateTags(forSelectedPreference: PushNotificationPreference.init(rawValue: selected)!)
  }
  
}
