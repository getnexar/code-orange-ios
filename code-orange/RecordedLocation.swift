//
//  CoronaLocation.swift
//  code-orange
//
//  Created by shani beracha on 15/03/2020.
//

import Foundation
import CoreLocation

let RADIUS_CONST = 30
let dataFormatter = ISO8601DateFormatter()

struct ServerRecordedLocation: Equatable, Codable {
  var lat: CLLocationDegrees
  var lon: CLLocationDegrees
  var startTime: String
  var endTime: String
  var radius: Int
  
  init(lat: CLLocationDegrees,
       lon: CLLocationDegrees,
       startTime: String,
       endTime: String,
       radius: Int) {
    self.lat = lat
    self.lon = lon
    self.startTime = startTime
    self.endTime = endTime
    self.radius = RADIUS_CONST
  }
}

struct RecordedLocation: Equatable, Codable {
  var location: CoronaLocation
  var startTime: Date
  var endTime: Date
  var address: String?
}

extension RecordedLocation {
  init?(serverLocation: ServerRecordedLocation) {
    self.location = CoronaLocation(lat: serverLocation.lat, lon: serverLocation.lon)
    guard let startTime = dataFormatter.date(from: serverLocation.startTime),
      let endTime = dataFormatter.date(from: serverLocation.endTime) else {
        return nil
    }
    
    self.startTime = startTime
    self.endTime = endTime
  }
  
  func isLocationColliding(with otherRecordedLocation: RecordedLocation,
                           collisionThresholdInMeters: Double) -> Bool {
    return self.location.isColliding(with: otherRecordedLocation.location,
                                    collisionThresholdInMeters: collisionThresholdInMeters)
  }
  
  func isTimeColliding(with otherRecordedLocation: RecordedLocation, collisionThresholdInSecs: Double) -> Bool {
    /*
     * we want at least one of the four couples s1-s2, s1-e2, e1-s2, e1-e2
     * to be less than matchingTimeThresholdInSecs apart from each other
     */
    let s1AndE1 = [self.startTime, self.endTime]
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

struct CoronaLocation: Equatable, Codable {
  var lat: CLLocationDegrees
  var lon: CLLocationDegrees
  
  func distance(from otherCoronaLocation: CoronaLocation) -> Double {
    // if this is too slow, do the calculation here instead o converting to CLLocation
    let location = CLLocation(latitude: lat, longitude: lon)
    let otherLocation = CLLocation(latitude: otherCoronaLocation.lat, longitude: otherCoronaLocation.lon)
    
    return location.distance(from: otherLocation)
  }
  
  func isColliding(with otherCoronaLocaion: CoronaLocation,
                  collisionThresholdInMeters: Double) -> Bool {
    return self.distance(from: otherCoronaLocaion) <= collisionThresholdInMeters
  }
}
