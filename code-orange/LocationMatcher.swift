//
//  LocationMatcher.swift
//  code-orange
//
//  Created by shani beracha on 15/03/2020.
//

import Foundation

struct MatchedLocation {
  var userLocation: RecordedLocation
  var infectedLocation: RecordedLocation
}

class LocationMatcher {
  
  let matchingDistanceThresholdInMeters: Double
  let matchingTimeThreshold: TimeInterval
  
  init(matchingTimeThreshold: TimeInterval, mathcingDistanceThresholdInMeters: Double) {
    self.matchingDistanceThresholdInMeters = mathcingDistanceThresholdInMeters
    self.matchingTimeThreshold = matchingTimeThreshold
  }
  
  func matchLocations(userLocations: [RecordedLocation],
                      coronaLocations: [RecordedLocation]) -> [MatchedLocation] {
    var matchingLocations = [MatchedLocation]()
    userLocations.forEach { userLocation in
      for coronaLocation in coronaLocations {
        if userLocation.isTimeColliding(with: coronaLocation, collisionThresholdInSecs: matchingTimeThreshold
          ),
          userLocation.isLocationColliding(with: coronaLocation, collisionThresholdInMeters: matchingDistanceThresholdInMeters) {
          matchingLocations.append(MatchedLocation(userLocation: userLocation, infectedLocation: coronaLocation))
          break
        }
      }
    }
    
    return matchingLocations
  }
}

