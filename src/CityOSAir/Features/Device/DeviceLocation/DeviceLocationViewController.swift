//
//  DeviceLocationViewController.swift
//  CityOSAir
//
//  Created by Haris Kovacevic on 02/07/2019.
//  Copyright © 2019 CityOS. All rights reserved.
//

import UIKit
import MapKit
import SnapKit

// MARK: - DeviceLocation Display Protocols
protocol DeviceLocationDisplayLogic: class {
  func displayError(_ error: NetworkError)
}

class DeviceLocationViewController: UIViewController, Progressable {
  var mapView: MKMapView = MKMapView()
  var marker: MKAnnotation!
  var devicePayload: AirDevicePayload!

  let closeButton = UIButton().autolayoutView()
  let headerLabel = UILabel().autolayoutView()
  let connectionMessageLabel = UILabel().autolayoutView()
  let continueButton = UIButton().autolayoutView()
  let connectionLabelBox = UIView().autolayoutView()
  let connectionLabel = UILabel().autolayoutView()

  var interactor: DeviceLocationBusinessLogic?
  var router: DeviceLocationRoutingLogic?

  var mainDeviceAddedProtocol: MainDeviceAddedProtocol?

  init(delegate: DeviceLocationRouterDelegate?, mainDeviceAddedProtocol: MainDeviceAddedProtocol?) {
    super.init(nibName: nil, bundle: nil)
    let interactor = DeviceLocationInteractor()
    let presenter = DeviceLocationPresenter()
    let router = DeviceLocationRouter()
    interactor.presenter = presenter
    presenter.viewController = self
    router.viewController = self
    router.delegate = delegate
    self.interactor = interactor
    self.router = router
    self.mainDeviceAddedProtocol = mainDeviceAddedProtocol
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    hideProgressHUD()
    setupMap()
    setupViews()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(true, animated: false)

  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.navigationController?.setNavigationBarHidden(false, animated: false)
  }

}

extension DeviceLocationViewController {

  func setupViews() {
    setupCloseButton()
    setupHeaderLabel()
    setupContinueButton()
    setupConnectionLabel()

    closeButton.addTarget(self, action: #selector(DeviceLocationViewController.close), for: .touchUpInside)
    continueButton.addTarget(self, action: #selector(DeviceLocationViewController.continuePressed), for: .touchUpInside)
  }

  func setupCloseButton() {
    view.addSubview(closeButton)

    closeButton.setImage(UIImage(named: "close"), for: .normal)

    closeButton.snp.makeConstraints {
      $0.width.equalTo(64)
      $0.height.equalTo(64)
      $0.right.equalTo(view)
      $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
    }
  }

  func setupHeaderLabel() {
    view.addSubview(headerLabel)

    headerLabel.textAlignment = .center
    headerLabel.text = "Device Location"
    headerLabel.numberOfLines = 0
    headerLabel.font = Styles.Detail.HeaderText.font
    headerLabel.textColor = Styles.Detail.HeaderText.tintColor


    headerLabel.snp.makeConstraints {
      $0.centerY.equalTo(closeButton)
      $0.centerX.equalTo(view)
    }
  }

  func setupContinueButton() {
    view.addSubview(continueButton)

    continueButton.setTitle("Continue", for: UIControl.State())
    continueButton.setType(type: AppButtonType.normal)
    continueButton.isEnabled = false

    continueButton.snp.makeConstraints {
      $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
      $0.left.equalTo(view).offset(24)
      $0.right.equalTo(view).offset(-24)
      $0.height.equalTo(50)
    }
  }

  func setupConnectionLabel() {
    view.addSubview(connectionLabelBox)
    view.addSubview(connectionLabel)

    connectionLabel.text = "Boxy is resetting its WiFi connection. Please wait for your phone to re-established the internet connection, and for the internet signal in status bar reappear. Map should be loaded and visible as well. When visible click on map to set the device's location."
    connectionLabel.textAlignment = .justified
    connectionLabel.numberOfLines = 0
    connectionLabel.adjustsFontSizeToFitWidth = false
    connectionLabel.font = Styles.Detail.SubtitleText.font
    connectionLabel.textColor = Styles.Detail.SubtitleText.tintColor

    connectionLabelBox.backgroundColor = .white
    connectionLabelBox.backgroundColor?.withAlphaComponent(0.2)

    connectionLabelBox.snp.makeConstraints {
      $0.left.equalTo(10)
      $0.right.equalTo(-10)
      $0.bottom.equalTo(continueButton.snp.top).offset(-10)
    }

    connectionLabel.snp.makeConstraints {
      $0.left.equalTo(connectionLabelBox.snp.left).offset(5)
      $0.top.equalTo(connectionLabelBox.snp.top).offset(5)
      $0.right.equalTo(connectionLabelBox.snp.right).offset(-5)
      $0.bottom.equalTo(connectionLabelBox.snp.bottom).offset(-5)
    }
  }

  func setupMap() {
    let latLng = UserManager.sharedInstance.currentCity.latLng
    centerMapOnLocation(CLLocation(latitude: latLng.latitude, longitude: latLng.longitude), mapView: mapView)
    view = mapView
    mapView.delegate = self

    let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(gestureRecognizer:)))
    mapView.addGestureRecognizer(gestureRecognizer)
  }

  @objc
  func handleTap(gestureRecognizer: UILongPressGestureRecognizer) {
    if marker != nil {
      mapView.removeAnnotation(marker)
    }
    let location = gestureRecognizer.location(in: mapView)
    let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
    
    guard coordinate.latitude != 0 && coordinate.longitude != 0 else {
      router?.navigateToAlert(title: "Error", message: "Failed to set location. Please try again.", handler: nil)
      return
    }

    // Add annotation:
    let annotation = MKPointAnnotation()
    annotation.coordinate = coordinate
    mapView.addAnnotation(annotation)
    
    marker = annotation
    continueButton.isEnabled = true
    devicePayload.coordinates = LatLng(lat: coordinate.latitude, lng: coordinate.longitude)
    
    //    let cllocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
    //    cllocation.geocode { placemark, error in
    //      if let _ = error as? CLError {
    //        self.router?.navigateToAlert(title: "Error", message: "Failed to get city from location. Please try again.", handler: nil)
    //      } else if let placemark = placemark?.first {
    //        log.info("name:", placemark.name ?? "unknown")
    //
    //        log.info("address1: " + (placemark.thoroughfare ?? "unknown"))
    //        log.info("address2: " + (placemark.subThoroughfare ?? "unknown"))
    //        log.info("neighborhood: " + (placemark.subLocality ?? "unknown"))
    //        log.info("city: " + (placemark.locality ?? "unknown"))
    //
    //        log.info("state: " + (placemark.administrativeArea ?? "unknown"))
    //        log.info("subAdministrativeArea: " + (placemark.subAdministrativeArea ?? "unknown"))
    //        log.info("zip code: " + (placemark.postalCode ?? "unknown"))
    //        log.info("country: " + (placemark.country ?? "unknown"))
    //
    //        log.info("isoCountryCode: " + (placemark.isoCountryCode ?? "unknown"))
    //        log.info("region identifier: " + (placemark.region?.identifier ?? "unknown"))
    //        self.devicePayload.city = placemark.subAdministrativeArea ?? "Sarajevo"
    //        self.continueButton.isEnabled = true
    //      }
    //    }

  }

  @objc
  func close() {
    router?.popToRootViewController()
  }

  @objc
  func continuePressed() {
    router?.navigateToDeviceDetails(payload: devicePayload, mainDeviceAddedProtocol: mainDeviceAddedProtocol)
  }

}

// MARK: - MapView Delegate
extension DeviceLocationViewController: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    if annotation is MKUserLocation {
      return nil
    }
    let identifier = "addedDevice"
    var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
    if pinView == nil {
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        pinView!.canShowCallout = false
    }
    else {
        pinView!.annotation = annotation
    }
    return pinView
  }
}

extension DeviceLocationViewController: DeviceLocationDisplayLogic {
  func displayError(_ error: NetworkError) {
    log.error(error)
    router?.navigateToAlert(title: "Error", message: error.message, handler: nil)
  }
}

// MARK: MapView methods
extension DeviceLocationViewController {
  func centerMapOnLocation(_ location: CLLocation, mapView: MKMapView, zoom: Double = 5000) {
    let regionRadius: CLLocationDistance = zoom
    let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
      latitudinalMeters: regionRadius * 2.0,
      longitudinalMeters: regionRadius * 2.0)
    mapView.setRegion(coordinateRegion, animated: true)
  }
}
