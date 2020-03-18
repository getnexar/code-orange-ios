//
//  CoronaLocation.swift
//  code-orange
//
//  Created by shani beracha on 15/03/2020.
//

import Foundation
import CoreLocation

struct COLocations: Codable {
  let locations: [COLocation]?

  private enum CodingKeys: String, CodingKey {
    case locations
  }
}

struct COLocation: Equatable, Codable {
  let lat: CLLocationDegrees
  let lon: CLLocationDegrees
  let startTime: Date
  let endTime: Date
  let radius: Double
  let name: String
  let comments: String

  private enum CodingKeys: String, CodingKey {
    case lat
    case lon
    case startTime
    case endTime
    case radius
    case name
    case comments
  }
}

extension COLocation {
  func isLocationColliding(with otherLocation: COLocation,
                           collisionThresholdInMeters: Double) -> Bool {
    let location1 = CLLocation(latitude: lat, longitude: lon)
    let location2 = CLLocation(latitude: otherLocation.lat, longitude: otherLocation.lon)

    return location1.distance(from: location2) <= collisionThresholdInMeters
  }

  func isTimeColliding(with otherRecordedLocation: COLocation,
                       collisionThresholdInSecs: Double) -> Bool {
    /*
     * we want at least one of the four couples s1-s2, s1-e2, e1-s2, e1-e2
     * to be less than matchingTimeThresholdInSecs apart from each other
     */
    let s1AndE1 = [startTime, endTime]
    let s2AndE2 = [otherRecordedLocation.startTime, otherRecordedLocation.endTime]
    var didFindMatch = false
    s1AndE1.forEach { firstDate in
      s2AndE2.forEach { SecondDate in
        didFindMatch = didFindMatch || (abs(firstDate.timeIntervalSince(SecondDate)) < collisionThresholdInSecs)
      }
    }

    return didFindMatch
  }
}

extension COLocation {
  var coordinates: CLLocationCoordinate2D {
    return CLLocationCoordinate2DMake(lat, lon)
  }
}

extension CLLocationCoordinate2D: Equatable, Hashable {
  
  public static func == (lhs: Self, rhs: Self) -> Bool {
    return lhs.longitude == rhs.longitude && lhs.latitude == rhs.latitude
  }
  
  public func hash(into hasher: inout Hasher) {
    hasher.combine(latitude)
    hasher.combine(longitude)
  }
}
