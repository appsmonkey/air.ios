//
//  DeviceCountClusterImageAnnotationView.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 1/2/20.
//  Copyright © 2020 CityOS. All rights reserved.
//

import UIKit
import MapKit
import Cluster

class DeviceCountClusterImageAnnotationView: ClusterAnnotationView {
  
  lazy var once: Void = { [unowned self] in
    self.countLabel.frame.size.width -= 6
    self.countLabel.frame.origin.x += 2
    self.countLabel.frame.origin.y += 5
    }()
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    _ = once
  }
}
