//
//  DeviceAnnotationView.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 12/29/19.
//  Copyright © 2019 CityOS. All rights reserved.
//

import UIKit
import MapKit

class DeviceAnnotationView: MKAnnotationView, MapKitReusable {

  override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
    super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    self.backgroundColor = UIColor.clear
    self.canShowCallout = false
    self.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

}
