//
//  LocationsProvider.swift
//  code-orange
//
//  Created by shani beracha on 15/03/2020.
//  Copyright © 2020 Renen Elal. All rights reserved.
//

import Foundation

struct Locations {
  var matchedLocations: [MatchedLocation]
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
    
    let matchingLocations = locationMatcher.matchLocations(userLocations: userLocations, coronaLocations: coronaLocations)
    let infectedMatchedLocations = matchingLocations.compactMap { $0.infectedLocation }
    let coronaNotMatchingLocations = coronaLocations.filter { !infectedMatchedLocations.contains($0) }
    return Locations(matchedLocations: matchingLocations, otherLocations: coronaNotMatchingLocations)
  }
  
  private func getStoredCoronaLocations() -> [RecordedLocation]? {
    // this is temp
    let communicator = Communicator()
    return communicator.getServerResults()
  }
  
  private func getStoredUserLocations() -> [RecordedLocation]? {
    let zones = StorageService.shared.getUserLocations()
    var recordedLocations = [RecordedLocation]()

    zones.forEach { zone in
      let location = CoronaLocation(lat: zone.latitude, lon: zone.longitude)
      // TODO: Validate the date
      let date = zone.dateEnter ?? Date(timeIntervalSince1970: 0.0)
      let recordedLocation = RecordedLocation(location: location, startTime: date, endTime: date)
      recordedLocations.append(recordedLocation)
    }

    return recordedLocations
  }
}
