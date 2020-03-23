//
//  CLLocationExtensions.swift
//  CityOSAir
//
//  Created by Danijel Kecman on 2/29/20.
//  Copyright © 2020 CityOS. All rights reserved.
//

import MapKit

extension CLLocation {
    func geocode(completion: @escaping (_ placemark: [CLPlacemark]?, _ error: Error?) -> Void)  {
        CLGeocoder().reverseGeocodeLocation(self, completionHandler: completion)
    }
}
