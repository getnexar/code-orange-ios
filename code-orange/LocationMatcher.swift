//
//  LocationMatcher.swift
//  code-orange
//
//  Created by shani beracha on 15/03/2020.
//

import Foundation

class LocationMatcher {
  
  let matchingDistanceThresholdInMeters: Double
  let matchingTimeThreshold: TimeInterval
  
  init(matchingTimeThreshold: TimeInterval, mathcingDistanceThresholdInMeters: Double) {
    self.matchingDistanceThresholdInMeters = mathcingDistanceThresholdInMeters
    self.matchingTimeThreshold = matchingTimeThreshold
  }
  
  func matchLocations(of userLocations: [RecordedLocation],
                      and coronaLocations: [RecordedLocation]) -> [RecordedLocation] {
    var matchingLocations = [RecordedLocation]()
    userLocations.forEach { userLocation in
      coronaLocations.forEach { coronaLocation in
        if userLocation.isTimeColliding(with: coronaLocation, collisionThresholdInSecs: matchingTimeThreshold
          ),
          userLocation.isLocationColliding(with: coronaLocation, collisionThresholdInMeters: matchingDistanceThresholdInMeters) {
          matchingLocations.append(userLocation)
        }
      }
    }
    
    return matchingLocations
  }
}

