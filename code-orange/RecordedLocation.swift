//
//  CoronaLocation.swift
//  code-orange
//
//  Created by shani beracha on 15/03/2020.
//

import Foundation
import CoreLocation

let RADIUS_CONST = 30
let dateFormatter = DateFormatter.iSO8601DateWithMillisec

extension DateFormatter {
  static var iSO8601DateWithMillisec: DateFormatter {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    return dateFormatter
  }
}

struct ServerRecordedLocation: Equatable, Codable {
  var lat: CLLocationDegrees
  var lon: CLLocationDegrees
  var startTime: String
  var endTime: String
  var radius: Int
  var name: String?
  var comments: String?
  
  init(lat: CLLocationDegrees,
       lon: CLLocationDegrees,
       startTime: String,
       endTime: String,
       radius: Int,
       name: String?,
       comments: String?) {
    self.lat = lat
    self.lon = lon
    self.startTime = startTime
    self.endTime = endTime
    self.radius = radius
    self.name = name
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
    guard let startTime = dateFormatter.date(from: serverLocation.startTime),
      let endTime = dateFormatter.date(from: serverLocation.endTime) else {
        return nil
    }
    
    self.startTime = startTime
    self.endTime = endTime
    self.address = serverLocation.name
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

extension CoronaLocation: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(lat)
    hasher.combine(lon)
  }
}
