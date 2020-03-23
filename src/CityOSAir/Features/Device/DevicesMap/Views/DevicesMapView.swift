//
//  DevicesMapView.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 12/29/19.
//  Copyright © 2019 CityOS. All rights reserved.
//

import UIKit
import MapKit

protocol DevicesMapViewTouchDelegate: class {
  func polygonsTapped(polygons: [CityOSPolygon])
}

class DevicesMapView: MKMapView {
  weak var devicesDelegate: DevicesMapViewTouchDelegate?
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

    if let touch = touches.first {
      if touch.tapCount == 1 {
        let touchLocation = touch.location(in: self)
        let locationCoordinate = self.convert(touchLocation, toCoordinateFrom: self)
        var polygons: [CityOSPolygon] = []
        for polygon in self.overlays as! [CityOSPolygon] {
          if polygon.contains(coordinate: locationCoordinate) {
            polygons.append(polygon)
          }
        }
        var isMarker = false
        for annotation in self.annotations {
          if locationCoordinate == annotation.coordinate {
            isMarker = true
          }
        }
        if polygons.count > 0 && !isMarker {
          self.devicesDelegate?.polygonsTapped(polygons: polygons)
        }
      }
    }

    super.touchesEnded(touches, with: event)
  }
}

extension MKPolygon {
  func contains(coordinate: CLLocationCoordinate2D) -> Bool {
    let renderer = MKPolygonRenderer(polygon: self)
    let mapPoint = MKMapPoint(coordinate)
    let viewPoint = renderer.point(for: mapPoint)
    return renderer.path.contains(viewPoint)
  }
}
