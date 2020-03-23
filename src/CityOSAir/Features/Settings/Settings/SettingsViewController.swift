//
//  SettingsViewController.swift
//  CityOSAir
//
//  Created by Andrej Saric on 29/08/16.
//  Copyright © 2016 CityOS. All rights reserved.
//

import UIKit
import UserNotifications

class SettingsViewController: UIViewController {

  lazy var backBtn: UIButton = {
    let btn = UIButton()
    btn.setImage(UIImage(named: "backbtn"), for: UIControl.State())
    btn.tintColor = UIColor.gray
    btn.addTarget(self, action: #selector(SettingsViewController.dimissViewController), for: .touchUpInside)
    return btn
  }()

  let header: UILabel = {
    let lbl = UILabel()
    lbl.font = Styles.Detail.HeaderText.font
    lbl.textColor = Styles.Detail.HeaderText.tintColor
    lbl.text = Text.Settings.title
    return lbl
  }()

  lazy var tableView: UITableView = {
    let table = UITableView()
    table.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    table.register(SettingsTableViewCell.self)
    table.dataSource = self
    table.delegate = self
    table.tableFooterView = UIView()
    table.separatorColor = UIColor.lightGray.withAlphaComponent(0.7)
    //  table.alwaysBounceVertical = false
    table.rowHeight = UITableView.automaticDimension
    table.estimatedRowHeight = 200
    return table
  }()

  var subscribedAlerts = "You are not subscribed to any alerts" {
    didSet {
      //doing on main because of
      //willEnterForeground case
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }
  }

  var isPushEnabled = false {
    didSet {
      //doing on main because of
      //willEnterForeground case
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white

    setupViews()

    //used to hide last cell
    tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.size.width, height: 1))

    NotificationCenter.default.addObserver(self, selector: #selector(SettingsViewController.isPushAuthorized),
                                           name: UIApplication.willEnterForegroundNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(SettingsViewController.updateSubscribedAlerts),
                                           name: UIApplication.willEnterForegroundNotification, object: nil)

  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    isPushAuthorized()
    updateSubscribedAlerts()
  }

  func setupViews() {
    view.addSubview(header)
    view.addSubview(backBtn)
    view.addSubview(tableView)

    let lineView = UIView()
    lineView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.7)

    view.addSubview(lineView)

    backBtn.snp.makeConstraints { (make) -> Void in
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(15)
      make.left.equalTo(view).offset(16)
    }

    header.snp.makeConstraints { (make) -> Void in
      make.centerY.equalTo(backBtn)
      make.centerX.equalTo(view)
    }

    lineView.snp.makeConstraints { (make) -> Void in
      make.top.equalTo(header.snp.bottom).offset(8)
      make.left.equalTo(view)
      make.right.equalTo(view)
      make.height.equalTo(0.5)
    }

    tableView.snp.makeConstraints { (make) -> Void in
      make.top.equalTo(lineView.snp.bottom)
      make.left.equalTo(view)
      make.right.equalTo(view)
      make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
    }
  }

  @objc func dimissViewController() {
    self.dismiss(animated: true)
  }
  
  func handleLoginLogout() {
    if AirUserManager.shared.isLoggedIn() {
//      FabricEventLogger.logCustomEvent(eventType: .logout, attributes: ["User Id": user.id, "Logout Date": Date().toString()])
      AirUserManager.shared.logout();

      let appDelegate = UIApplication.shared.delegate as! AppDelegate;
      let loginViewController = LoginViewController(delegate: nil)
      let navigationViewController = UINavigationController(rootViewController: loginViewController)
      appDelegate.window?.rootViewController = navigationViewController
    } else {
      let loginViewController = LoginViewController(delegate: nil)
      loginViewController.shouldClose = true
      let navigationViewController = UINavigationController(rootViewController: loginViewController)
      navigationViewController.modalPresentationStyle = .fullScreen
      present(navigationViewController, animated: true, completion: nil)
    }
  }

  @objc func isPushAuthorized() {
    if #available(iOS 10.0, *) {
      let center = UNUserNotificationCenter.current()

      center.getNotificationSettings { (settings) in
        if(settings.authorizationStatus == .authorized) {
          self.isPushEnabled = true
        } else{
          self.isPushEnabled = false
        }
      }
    } else {
      isPushEnabled = UIApplication.shared.isRegisteredForRemoteNotifications
    }
  }

  @objc func updateSubscribedAlerts() {
    if let pushNotificationPreference = PushNotificationPreference.getSelectedPreference() {
      self.subscribedAlerts = pushNotificationPreference.label
    } else {
      self.subscribedAlerts = "You are not subscribed to any alerts"
    }
  }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3 //Config.appConfiguration == .testFlight ? 5 : 4
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    var cell: UITableViewCell!

    switch (indexPath as NSIndexPath).row {
      /*case 0:
            cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as SettingsTableViewCell
            (cell as! SettingsTableViewCell).configure(rightDetailText: UserManager.sharedInstance.currentCity.rawValue)
            (cell as! SettingsTableViewCell).titleLabel.text = "Current City"
            (cell as! SettingsTableViewCell).subtitleLabel.text = "Choose your city"
            return cell*/
    case 0:
      cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as SettingsTableViewCell
      (cell as! SettingsTableViewCell).configure(rightDetailText: isPushEnabled ? "On" : "Off")
      (cell as! SettingsTableViewCell).titleLabel.text = Text.Settings.notificationsTitle
      (cell as! SettingsTableViewCell).subtitleLabel.text = Text.Settings.notificationsDetail
      return cell
    case 1:
      cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as SettingsTableViewCell
      (cell as! SettingsTableViewCell).configure()
      (cell as! SettingsTableViewCell).titleLabel.text = Text.Settings.notifyMe
      (cell as! SettingsTableViewCell).subtitleLabel.text = subscribedAlerts
    case 2:
      cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

      cell.textLabel?.textColor = Styles.SmallButton.tintColor
      cell.accessoryType = .none

      if AirUserManager.shared.isLoggedIn() {
        cell.textLabel?.text = Text.Settings.logout
      } else {
        cell.textLabel?.text = Text.Settings.login
      }
//        case 4:
//            cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
//
//            cell.textLabel?.textColor = Styles.SmallButton.tintColor
//            cell.accessoryType = .none
//
//            cell.textLabel?.text = "Test flight info"
    default:
      break
    }
    
    cell.textLabel?.font = Styles.SmallButton.font
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    switch (indexPath as NSIndexPath).row {
    case 0:
      let url = URL(string: UIApplication.openSettingsURLString)!
      UIApplication.shared.open(url)
    case 1:
      self.navigationController?.pushViewController(AlertsViewController(), animated: true)
    case 2:
      handleLoginLogout()
    default:
      break
    }
  }

  func showCitySelect() {
    let alert = UIAlertController(title: nil, message: "Choose a city", preferredStyle: .actionSheet)
    alert.addAction(UIAlertAction(title: "Sarajevo", style: .default, handler: { action in
      UserManager.sharedInstance.currentCity = AirCity.sarajevo
      self.tableView.reloadData()
    }))

    alert.addAction(UIAlertAction(title: "Belgrade", style: .default, handler: { action in
      UserManager.sharedInstance.currentCity = AirCity.belgrade
      self.tableView.reloadData()
    }))
    alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))

    present(alert, animated: true, completion: nil)
  }

  fileprivate func getTestFlightInfo() {
    let info = "App Version: \(Bundle.main.releaseVersionNumber ?? "Unable to fetch")\nApp Build: \(Bundle.main.buildVersionNumber ?? "Unable to fetch")\nUsing baseUrl: \(Constants.Api.baseUrl)"

    let alert = UIAlertController(title: info, message: nil, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
    present(alert, animated: true, completion: nil)
  }

}

//extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 3
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        var cell:UITableViewCell!
//
//        switch (indexPath as NSIndexPath).row {
//
//        case 0:
//            cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as SettingsTableViewCell
//            (cell as! SettingsTableViewCell).configure(rightDetailText: isPushEnabled ? "On" : "Off")
//            (cell as! SettingsTableViewCell).titleLabel.text = Text.Settings.notificationsTitle
//            (cell as! SettingsTableViewCell).subtitleLabel.text = Text.Settings.notificationsDetail
//            return cell
//        case 1:
//            cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as SettingsTableViewCell
//            (cell as! SettingsTableViewCell).configure()
//            (cell as! SettingsTableViewCell).titleLabel.text = Text.Settings.notifyMe
//            (cell as! SettingsTableViewCell).subtitleLabel.text = subscribedAlerts
//        case 2:
//            cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
//
//            cell.textLabel?.textColor = Styles.SmallButton.tintColor
//            cell.accessoryType = .none
//
//            if let _ = UserManager.sharedInstance.getLoggedInUser() {
//                cell.textLabel?.text = Text.Settings.logout
//            }else {
//                cell.textLabel?.text = Text.Settings.login
//            }
//        default:
//            break
//        }
//
//        cell.textLabel?.font = Styles.SmallButton.font
//
//
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        tableView.deselectRow(at: indexPath, animated: true)
//
//        switch (indexPath as NSIndexPath).row {
//
//        case 0:
//            UIApplication.shared.openURL(NSURL(string: UIApplicationOpenSettingsURLString)! as URL)
//        case 1:
//            self.navigationController?.pushViewController(AlertsViewController(), animated: true)
//        case 2:
//            handleLoginLogout()
//        default:
//            break
//        }
//    }
//
//}
