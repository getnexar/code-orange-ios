//
//  LocationProvider.swift
//  code-orange
//
//  Created by Renen Elal on 15/03/2020.
//  Copyright © 2020 Renen Elal. All rights reserved.
//

import Foundation
import CoreLocation

protocol CurrentLocationProvider: class {
  var currentLocation: CLLocationCoordinate2D { get }
}
