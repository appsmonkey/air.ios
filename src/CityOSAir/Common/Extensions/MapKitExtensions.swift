//
//  MapKitExtensions.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 12/29/19.
//  Copyright © 2019 CityOS. All rights reserved.
//

import Foundation
import MapKit

extension MKMapView {

  func dequeueReusableAnnotationView<T: MKAnnotationView>(annotation: MKAnnotation, annotationViewType: T.Type = T.self) -> T where T: MapKitReusable {
    if let view = dequeueReusableAnnotationView(withIdentifier: annotationViewType.reuseIdentifier) as? T {
      return view
    } else {
      return T(annotation: annotation, reuseIdentifier: annotationViewType.reuseIdentifier)
    }
  }
}

extension MKMapView {
  func annotationView<T: MKAnnotationView>(of type: T.Type, annotation: MKAnnotation?, reuseIdentifier: String) -> T {
    guard let annotationView = dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) as? T else {
      return type.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    }
    annotationView.annotation = annotation
    return annotationView
  }
}


extension MKAnnotationView: Reusable { }
