//
//  DevicesMapViewController.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 12/26/19.
//  Copyright © 2019 CityOS. All rights reserved.
//

import UIKit
import SnapKit
import MapKit
import Cluster

// MARK: - Display Protocols
protocol DevicesMapDisplayLogic: class {
  func displayMapError(_ error: Error)
  func displayMapData(for devices: [AirDevice], mapZones: [Zone])
}

class DevicesMapViewController: UIViewController {
  var interactor: DevicesMapViewBusinessLogic?
  var router: DevicesMapRoutingLogic?

  lazy var mapViewContentView = DevicesMapContentView.autolayoutView()
  lazy var mapInfoView = MapInfoView().autolayoutView()

  // var to store api devices currently on the map.
  // workaround so a user can click on info of any device and be taken to the device screen.
  var devices: [AirDevice] = [AirDevice]()

  var deviceName: String = ""
  var deviceType = "outdoor"
  var isDeviceIndoor: Bool = false
  var selectedAnnotationView: DeviceAnnotationView?
  var selectedDevice: AirDevice?

  let defaultFillOpacity: CGFloat = 0.4
  let tappedFillOpacity: CGFloat = 0.6

  var mapView = DevicesMapView()
  let clusterManager = ClusterManager()
  var zones: [Zone] = []
  var places: [CTOSMapPlace] = []
  var filteredDevices = [AirDevice]()
  var infoViewHeight: CGFloat = 0
  var cityCentered = false

  var currentPolygon: CityOSPolygon? {
    willSet {
      if let poly = currentPolygon {
        mapView.addOverlay(poly)
      }
    }
  }

  // MARK: - View Cycle
  init(delegate: DevicesMapRouterDelegate?) {
    super.init(nibName: nil, bundle: nil)
    let interactor = DevicesMapInteractor()
    let presenter = DevicesMapPresenter()
    let router = DevicesMapRouter()
    interactor.presenter = presenter
    presenter.viewController = self
    router.viewController = self
    router.delegate = delegate
    self.interactor = interactor
    self.router = router
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    slideMenuController()?.delegate = self
    UserManager.sharedInstance.delegate = self
    mapViewContentView.devicesSegment.selectedIndex = isDeviceIndoor ? 1 : 0

    places = CTOSPlaceHandler.getPlaces(city: UserManager.sharedInstance.currentCity.rawValue)

    let latLng = UserManager.sharedInstance.currentCity.latLng
    centerMapOnLocation(CLLocation(latitude: latLng.latitude, longitude: latLng.longitude), mapView: mapView)
    view = mapView
    mapView.delegate = self
    mapView.devicesDelegate = self

    setupViews()
    refreshMap()
  }

  // MARK: - Setup Screen
  func setupViews() {
    view.addSubview(mapViewContentView)
    view.addSubview(mapInfoView)

    detectDevice()

    clusterManager.delegate = self
    clusterManager.maxZoomLevel = 17
    clusterManager.minCountForClustering = 2
    clusterManager.clusterPosition = .nearCenter

    mapViewContentView.snp.makeConstraints {
      $0.height.equalTo(30)
      $0.leading.trailing.equalToSuperview()
      $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
    }

    mapViewContentView.devicesSegment.isEnabled = true
    mapViewContentView.menuButton.addTarget(self, action: #selector(openMenu), for: .touchUpInside)
    mapViewContentView.chartButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
    mapViewContentView.devicesSegment.addTarget(self, action: #selector(indexChanged(sender:)), for: .valueChanged)

    mapInfoView.delegate = self
    mapInfoView.infoViewHeight = infoViewHeight
    mapInfoView.setupView()

    if isDeviceIndoor {
      deviceType = "indoor"
    }
  }

  func detectDevice() {
    if UIDevice().userInterfaceIdiom == .phone {
      switch UIScreen.main.nativeBounds.height {
      case 1136:
        print("iPhone 5 or 5S or 5C")
        infoViewHeight = 130

      case 1334:
        print("iPhone 6/6S/7/8")
        infoViewHeight = 140

      case 1920, 2208:
        print("iPhone 6+/6S+/7+/8+")
        infoViewHeight = 150

      case 2436:
        print("iPhone X/XS/11 Pro")
        infoViewHeight = 180

      case 2688:
        print("iPhone XS Max/11 Pro Max")
        infoViewHeight = 180

      case 1792:
        print("iPhone XR/ 11 ")
        infoViewHeight = 180

      default:
        print("Unknown")
        infoViewHeight = 150
      }
    }
  }

  @objc
  func openMenu() {
    self.slideMenuController()?.openLeft()
  }

  @objc
  func goBack() {
    guard let menuViewContoller = self.slideMenuController()?.leftViewController as? MenuViewController else { return }
    menuViewContoller.transitionToCity()
  }

  @objc
  func indexChanged(sender: UISegmentedControl) {
    mapInfoView.hide()
    refreshDevices(with: mapViewContentView.devicesSegment.selectedIndex)
  }

  @objc
  func refreshMap() {
    mapInfoView.hide()
    interactor?.getMapDataForDevice(type: deviceType)
  }

}

// MARK: - Slide Menu Protocols
extension DevicesMapViewController: SlideMenuControllerDelegate {

  func startedPan() {
    mapView.isUserInteractionEnabled = false
  }

  func endedPan() {
    mapView.isUserInteractionEnabled = true
  }
}

extension DevicesMapViewController: UserManagable {
  func didSwitchToCity(city: AirCity) {
    places = CTOSPlaceHandler.getPlaces(city: city.rawValue)

    let latLng = city.latLng
    centerMapOnLocation(CLLocation(latitude: latLng.latitude, longitude: latLng.longitude), mapView: mapView)

    refreshMap()
  }
}

// MARK: - Setup Map
extension DevicesMapViewController {

  func refreshDevices(with index: Int) {
    let filter = DeviceFilter(rawValue: index)!
    filteredDevices = [AirDevice]()
    switch(filter) {
    case .Indoor:
      deviceType = "indoor"
      break
    case .Outdoor:
      deviceType = "outdoor"
      break
    case .Mine:
      deviceType = "mine"
      break
    }
    interactor?.getMapDataForDevice(type: deviceType)
  }

  func filterDevices() {
    if deviceType == Constants.DeviceType.mine {
      filteredDevices = devices.filter({ $0.mine })
    } else if deviceType == Constants.DeviceType.indoor {
      filteredDevices = devices.filter({ $0.indoor })
    } else if deviceType == Constants.DeviceType.outdoor {
      filteredDevices = devices.filter({ !$0.indoor })
    }
  }

  func createMarkers(forDevices devices: [AirDevice]) {
    var annotations = [Annotation]()

    for device in devices where device.active || device.mine {
      let mapDevice = MapDeviceMarker(device: device)
      let coordinate = CLLocationCoordinate2D(latitude: (mapDevice.device.location?.lat)!, longitude: (mapDevice.device.location?.lng)!)
      let annotation = DeviceAnnotation(coordinate: coordinate)
      let selected = deviceName == mapDevice.device.name
      annotation.imageName = getAnnotationViewImageName(device: mapDevice, selected: selected, mine: mapDevice.device.mine)
      annotation.userData = mapDevice
      annotations.append(annotation)

      if device.name != "" && deviceName != Constants.Readings.sarajevo && device.name == deviceName {
        selectedDevice = device
        mapView.selectAnnotation(annotation, animated: true)
        zoomOnDevice(device: device)
      }
    }

    clusterManager.add(annotations)
    clusterManager.reload(mapView: mapView)
  }

  func showInfoForDevice(_ device: AirDevice) {
    let mapDevice = MapDeviceMarker(device: device)
    var temperature: Double? = nil
    if let temp = device.mapMeta?["AIR_TEMPERATURE"]?.value, let level = device.mapMeta?["AIR_TEMPERATURE"]?.level, !level.isEmpty {
      temperature = temp
    }
    showMapInfo(title: mapDevice.device.name,
      aqi: mapDevice.aqi,
      pm25Val: mapDevice.pm25,
      pm10Val: mapDevice.pm10,
      tempVal: temperature,
      active: device.active)
  }

  func getAnnotationViewImageName(device: MapDeviceMarker, selected: Bool, mine: Bool) -> String {
    if device.aqi.rawValue == .zero {
      log.info(device.aqi)
    }
    var assetName = "box-\(device.aqi.rawValue)"
    if mine {
      assetName = "my-\(assetName)"
    }
    if selected {
      assetName = "\(assetName)-selected"
    }

    return assetName
  }

  func zoomOnDevice(device: AirDevice) {
    if let location = device.location, location.lat != 0, location.lng != 0 {
      centerMapOnLocation(CLLocation(latitude: location.lat, longitude: location.lng), mapView: mapView, zoom: 500)
    } else {
      centerMapOnLocation(CLLocation(latitude: Constants.Location.Sarajevo.latitude, longitude: Constants.Location.Sarajevo.latitude), mapView: mapView)
    }
  }

  func createPolys(forPlace place: CTOSMapPlace, andforDevices devices: [AirDevice]) {
    let zone = getZone(with: place)
    var locations = place.polygon.map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }
    let ctosPoly = CityOSPolygon(coordinates: &locations, count: locations.count)

    ctosPoly.zone = zone

    ctosPoly.updateAqi()

    ctosPoly.title = place.title
    ctosPoly.fillColor = ctosPoly.aqi.fillColor.withAlphaComponent(defaultFillOpacity)
    ctosPoly.strokeColor = ctosPoly.aqi.strokeColor
    ctosPoly.strokeWidth = 2

    ctosPoly.isTappable = true

    mapView.addOverlay(ctosPoly, level: .aboveRoads)
  }

  func getZone(with place: CTOSMapPlace) -> Zone? {
    var mapZone = zones.first(where: { place.title.elementsEqual($0.zoneName) })
    for zone in zones where zone.zoneName == place.title {
      let pm25 = zone.data.first(where: { "PM2.5".elementsEqual($0.measurement) })?.value
      let pm10 = zone.data.first(where: { "PM10".elementsEqual($0.measurement) })?.value
      let pm25AQI = AQI.getAQIForTypeWithValue(value: pm25, aqiType: .pm25)
      let pm10AQI = AQI.getAQIForTypeWithValue(value: pm10, aqiType: .pm10)
      if pm25AQI.rawValue > pm10AQI.rawValue {
        mapZone = zone
      }
    }
    return mapZone
  }

  func fillPolys(forPlace place: CTOSMapPlace, andforDevices devices: [AirDevice]) {
    let zone = zones.first(where: { place.title.elementsEqual($0.zoneName) })
    guard let poly = (mapView.overlays.first { $0.title == place.title }) as? CityOSPolygon else { return }
    var aqi: AQI = .zero
    let pm25 = zone?.data.first(where: { "PM2.5".elementsEqual($0.measurement) })?.value
    let pm10 = zone?.data.first(where: { "PM10".elementsEqual($0.measurement) })?.value
    let pm25AQI = AQI.getAQIForTypeWithValue(value: pm25, aqiType: .pm25)
    let pm10AQI = AQI.getAQIForTypeWithValue(value: pm10, aqiType: .pm10)
    aqi = pm25AQI.rawValue > pm10AQI.rawValue ? pm25AQI : pm10AQI
    if poly.fillColor != aqi.fillColor.withAlphaComponent(defaultFillOpacity) {
      poly.fillColor = aqi.fillColor.withAlphaComponent(defaultFillOpacity)
      poly.strokeColor = aqi.strokeColor
      mapView.removeOverlay(poly)
      mapView.addOverlay(poly)
    }
  }

  func showMapInfo(title: String?, aqi: AQI, pm25Val: Double?, pm10Val: Double?, tempVal: Double?, active: Bool?) {
    mapInfoView.hide()
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
      let clickable = self.devices.contains { $0.name == title }
      self.mapInfoView.updateValues(title: title,
        aqi: aqi,
        pm25Val: pm25Val,
        pm10Val: pm10Val,
        tempVal: tempVal,
        isClickable: clickable,
        active: active)
    }
  }

}

// MARK: - Map Info Delegate
extension DevicesMapViewController: MapInfoViewTappable {
  func didClickOnView(with name: String) {
    guard let menuViewController = self.slideMenuController()?.leftViewController as? MenuViewController else { return }

    menuViewController.transitionToDevice(name: name)
  }
}

// MARK: MapView methods
extension DevicesMapViewController {
  func centerMapOnLocation(_ location: CLLocation, mapView: MKMapView, zoom: Double = 5000) {
    let regionRadius: CLLocationDistance = zoom
    let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
    mapView.setRegion(coordinateRegion, animated: true)
    if !cityCentered {
      cityCentered = true
      DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
        if let device = self.selectedDevice {
          self.showInfoForDevice(device)
        }
      }
    }
  }
}

// MARK: - DevicesMapViewTouch Delegate
extension DevicesMapViewController: DevicesMapViewTouchDelegate {
  func polygonsTapped(polygons: [CityOSPolygon]) {
    guard let polygon = polygons.first else { return }
    if let previousAnnotationView = selectedAnnotationView, let previousAnnotation = previousAnnotationView.annotation as? DeviceAnnotation,
      let previousDevice = previousAnnotation.userData {
      let imageName = getAnnotationViewImageName(device: previousDevice, selected: false, mine: previousDevice.device.mine)
      previousAnnotationView.image = UIImage(named: imageName)
      //selectedAnnotationView = nil
    }
    showMapInfo(title: polygon.title, aqi: polygon.aqi, pm25Val: polygon.pm25, pm10Val: polygon.pm10, tempVal: nil, active: nil)
  }
}

// MARK: - MapView Delegate
extension DevicesMapViewController: MKMapViewDelegate {

  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    if annotation is MKUserLocation {
      return nil
    }

    if annotation is ClusterAnnotation {
      let annotationView = mapView.annotationView(of: DeviceCountClusterImageAnnotationView.self,
        annotation: annotation,
        reuseIdentifier: "clusterAnnotation")
      if case let annotation = annotation as? ClusterAnnotation,
        let annotations = annotation?.annotations as? [DeviceAnnotation] {
        var pm10value: Double = 0.0
        var pm25value: Double = 0.0
        var count: Double = 0.0
        for annotation in annotations where annotation.userData != nil {
          if annotation.userData!.pm10 != nil && annotation.userData!.pm25 != nil {
            count += 1
            pm10value += annotation.userData!.pm10!
            pm25value += annotation.userData!.pm25!
          }
        }
        if count != 0 {
          pm10value = pm10value / count
          pm25value = pm25value / count
          let pm25AQI = AQI.getAQIForTypeWithValue(value: pm25value, aqiType: .pm25)
          let pm10AQI = AQI.getAQIForTypeWithValue(value: pm10value, aqiType: .pm10)

          let aqi = pm25AQI.rawValue > pm10AQI.rawValue ? pm25AQI : pm10AQI
          let imageName = getClusterImage(with: aqi.rawValue)

          annotationView.image = UIImage(named: imageName)
          annotationView.countLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
          annotationView.countLabel.tintColor = .white
        } else {
          annotationView.image = UIImage(named: "box-gray-group")
          annotationView.countLabel.tintColor = .white
        }
      }
      return annotationView
    } else {
      guard let annotation = annotation as? DeviceAnnotation else { return nil }
      let annotationView = mapView.dequeueReusableAnnotationView(annotation: annotation) as DeviceAnnotationView
      if annotation.userData?.device.name == deviceName {
        selectedAnnotationView = annotationView
      }
      annotationView.annotation = annotation
      annotationView.image = UIImage(named: annotation.imageName!)
      return annotationView
    }
  }

  func getClusterImage(with aqiValue: Int) -> String {
    switch aqiValue {
    case 0:
      return "box-gray-group"
    case 1:
      return "box-blue-group"
    case 2:
      return "box-green-group"
    case 3:
      return "box-yellow-group"
    case 4:
      return "box-orange-group"
    case 5:
      return "box-purple-group"
    case 6:
      return "box-red-group"
    default:
      return "box-gray-group"
    }
  }

  func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    guard let polygon = overlay as? CityOSPolygon else {
      return MKOverlayRenderer()
    }

    let renderer = MKPolygonRenderer(polygon: polygon)
    renderer.fillColor = polygon.fillColor
    renderer.strokeColor = polygon.strokeColor
    renderer.lineWidth = polygon.strokeWidth!
    return renderer
  }

  func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    guard let annotation = view.annotation else { return }
    mapInfoView.hide()
    if let cluster = annotation as? ClusterAnnotation {
      var zoomRect = MKMapRect.null
      for annotation in cluster.annotations {
        let annotationPoint = MKMapPoint(annotation.coordinate)
        let pointRect = MKMapRect(x: annotationPoint.x, y: annotationPoint.y, width: 0, height: 0)
        if zoomRect.isNull {
          zoomRect = pointRect
        } else {
          zoomRect = zoomRect.union(pointRect)
        }
      }
      mapView.setVisibleMapRect(zoomRect, animated: true)
    } else {
      guard let annotationView = view as? DeviceAnnotationView else { return }
      guard let annotation = view.annotation as? DeviceAnnotation else { return }
      guard let device = annotation.userData else { return }

      if let previousAnnotationView = selectedAnnotationView, let previousAnnotation = previousAnnotationView.annotation as? DeviceAnnotation,
        let previousDevice = previousAnnotation.userData {
        let imageName = getAnnotationViewImageName(device: previousDevice, selected: false, mine: previousDevice.device.mine)
        previousAnnotationView.image = UIImage(named: imageName)
      }

      let imageName = getAnnotationViewImageName(device: device, selected: true, mine: device.device.mine)
      annotationView.image = UIImage(named: imageName)

      let title = device.device.name
      let aqi = device.aqi
      let pm10 = device.pm10
      let pm25 = device.pm25
      var temperature: Double? = nil
      if let temp = device.device.mapMeta?["AIR_TEMPERATURE"]?.value, let level = device.device.mapMeta?["AIR_TEMPERATURE"]?.level, !level.isEmpty {
        temperature = temp
      }
      showMapInfo(title: title, aqi: aqi, pm25Val: pm25, pm10Val: pm10, tempVal: temperature, active: device.device.active)
      selectedAnnotationView = annotationView
      mapView.deselectAnnotation(annotation, animated: false)
    }
  }

  func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
    if let previousAnnotationView = selectedAnnotationView, let previousAnnotation = previousAnnotationView.annotation as? DeviceAnnotation,
      let previousDevice = previousAnnotation.userData {
      let imageName = getAnnotationViewImageName(device: previousDevice, selected: false, mine: previousDevice.device.mine)
      previousAnnotationView.image = UIImage(named: imageName)
      selectedAnnotationView = nil
    }
  }

  func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
    mapInfoView.hide()
  }

  func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
    clusterManager.reload(mapView: mapView) { finished in
      print(finished)
    }
  }

  func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
    views.forEach { $0.alpha = 0 }
    UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: {
        views.forEach { $0.alpha = 1 }
      }, completion: nil)
  }

}

// MARK: - Cluster Manager Delegate
extension DevicesMapViewController: ClusterManagerDelegate {

  func cellSize(for zoomLevel: Double) -> Double? {
    return nil // default
  }

  func shouldClusterAnnotation(_ annotation: MKAnnotation) -> Bool {
    return true
  }

}

// MARK: - Display Protocols Implementation
extension DevicesMapViewController: DevicesMapDisplayLogic {

  func displayMapData(for devices: [AirDevice], mapZones: [Zone]) {
    mapInfoView.hide()
    DeviceStore.shared.save(devices: devices)
    self.devices = devices
    self.zones = mapZones

    if filteredDevices.count == 0 {
      filterDevices()
    }

    mapView.removeOverlays(mapView.overlays)
    clusterManager.removeAll()
    clusterManager.reload(mapView: mapView)
    places.forEach({ createPolys(forPlace: $0, andforDevices: filteredDevices) })
    createMarkers(forDevices: filteredDevices)
  }

  func displayMapError(_ error: Error) {
    log.info(error)
    router?.navigateToAlert(title: "Map Error!", message: error.localizedDescription, handler: nil)
  }

}
