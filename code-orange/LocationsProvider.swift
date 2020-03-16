//
//  LocationsProvider.swift
//  code-orange
//
//  Created by shani beracha on 15/03/2020.
//  Copyright © 2020 Renen Elal. All rights reserved.
//

import Foundation

struct Locations {
  var matchedLocations: [RecordedLocation]
  var otherLocations: [RecordedLocation]
}

class LocationsProvider {
  
  private let locationMatcher: LocationMatcher
  
  init(locationMatcher: LocationMatcher) {
    self.locationMatcher = locationMatcher
  }

  public func getLocations() -> Locations {
    guard let coronaLocations = getStoredCoronaLocations() else {
      return Locations(matchedLocations: [], otherLocations: [])
    }
    
    guard let userLocations = getStoredUserLocations() else {
      return Locations(matchedLocations: [], otherLocations: coronaLocations)
    }
    
    let matchingLocations = locationMatcher.matchLocations(of: coronaLocations, and: userLocations)
    let coronaNotMatchingLocations = coronaLocations.filter { !matchingLocations.contains($0) }
    return Locations(matchedLocations: matchingLocations, otherLocations: coronaNotMatchingLocations)
  }
  
  private func getStoredCoronaLocations() -> [RecordedLocation]? {
    // this is temp
    let communicator = Communicator()
    return communicator.getServerResults()
  }
  
  private func getStoredUserLocations() -> [RecordedLocation]? {
    // this is temp
    let communicator = Communicator()
    return communicator.getUserData()
  }
}
