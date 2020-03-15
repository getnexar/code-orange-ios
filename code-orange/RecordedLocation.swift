//
//  CoronaLocation.swift
//  code-orange
//
//  Created by shani beracha on 15/03/2020.
//

import Foundation
import CoreLocation

let RADIUS_CONST = 30

struct RecordedLocation: Equatable, Codable {
  var lat: CLLocationDegrees
  var lon: CLLocationDegrees
  var startTime: Int
  var endTime: Int
  var radius: Int
  
  init(lat: CLLocationDegrees,
       lon: CLLocationDegrees,
       startTime: Int,
       endTime: Int) {
    self.lat = lat
    self.lon = lon
    self.startTime = startTime
    self.endTime = endTime
    self.radius = RADIUS_CONST
  }
}
