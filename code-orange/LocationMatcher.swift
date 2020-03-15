//
//  LocationMatcher.swift
//  code-orange
//
//  Created by shani beracha on 15/03/2020.
//

import Foundation

class LocationMatcher {
  
  static let mathcingDistanceThresholdInMeter = 30.0
  static let matchingTimeThresholdInMins = 30.0
  static let matchingTimeThresholdInSecs = LocationMatcher.matchingTimeThresholdInMins * 60
  
  // return value: an array of the user locations matching. empty array if there are no matches
  static func getMatchedLocations(of userLocations: [RecordedLocation],
                                  and coronaLocations: [RecordedLocation]) -> [RecordedLocation] {
    var matchingLocations = [RecordedLocation]()
    userLocations.forEach { userLocation in
      coronaLocations.forEach { coronaLocation in
        if userLocation.isTimeColliding(with: coronaLocation, collisionThresholdInSecs: Self.matchingTimeThresholdInSecs),
          userLocation.isLocationColliding(with: coronaLocation, collisionThresholdInMeters: Self.mathcingDistanceThresholdInMeter) {
          matchingLocations.append(userLocation)
        }
      }
    }
    
    return matchingLocations
  }
}
