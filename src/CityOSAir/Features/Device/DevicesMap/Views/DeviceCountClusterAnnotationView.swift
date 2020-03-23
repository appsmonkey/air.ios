//
//  DeviceCountAnnotationView.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 1/2/20.
//  Copyright © 2020 CityOS. All rights reserved.
//

import UIKit
import MapKit
import Cluster

class DeviceCountClusterAnnotationView: ClusterAnnotationView {
  override func configure() {
    super.configure()
    
    guard let annotation = annotation as? ClusterAnnotation else { return }
    let count = annotation.annotations.count
    let diameter = radius(for: count) * 2
    self.frame.size = CGSize(width: diameter, height: diameter)
    self.layer.cornerRadius = self.frame.width / 2
    self.layer.masksToBounds = true
    self.layer.borderColor = UIColor.white.cgColor
    self.layer.borderWidth = 1.5
  }
  
  func radius(for count: Int) -> CGFloat {
    if count < 5 {
      return 12
    } else if count < 10 {
      return 16
    } else {
      return 20
    }
  }
}

