//
//  CoordinatesProvider.swift
//  code-orange
//
//  Created by Renen Elal on 15/03/2020.
//  Copyright © 2020 Renen Elal. All rights reserved.
//

import Foundation
import CoreLocation

protocol CoordinatesProviderDelegate: class {
  func coordinatesProviderUpdated(_ sender: CoordinatesProvider)
}

protocol CoordinatesProvider: class {
  var coordinates: [CLLocationCoordinate2D] { get }
  var delegate: CoordinatesProviderDelegate? { get set }
}
