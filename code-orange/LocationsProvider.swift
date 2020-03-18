//
//  LocationsProvider.swift
//  code-orange
//
//  Created by shani beracha on 15/03/2020.
//  Copyright © 2020 Renen Elal. All rights reserved.
//

import Foundation
import CoreLocation

struct Locations {
  var matchedLocations: [MatchedLocation]
  var otherLocations: [RecordedLocation]
}

class LocationsProvider {
  
  private let locationMatcher: LocationMatcher
  private let dataFetcher: DataFetcher
  
  init(locationMatcher: LocationMatcher, dataFetcher: DataFetcher) {
    self.locationMatcher = locationMatcher
    self.dataFetcher = dataFetcher
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
    let infectedLocation = dataFetcher.getInfectedLocations()
    let recordedLocations = infectedLocation.compactMap { RecordedLocation(serverLocation: $0)}
    return recordedLocations
  }
  
  private func getStoredUserLocations() -> [RecordedLocation]? {
    let zones = StorageService.shared.getUserLocations()
    var recordedLocations = [RecordedLocation]()

    zones.forEach { zone in
      let location = CoronaLocation(lat: zone.latitude, lon: zone.longitude)
      // TODO: Validate the date
      let startTime = zone.startTime ?? Date(timeIntervalSince1970: 0.0)
      let endTime = zone.endTime ?? Date(timeIntervalSince1970: 0.0)
      let recordedLocation = RecordedLocation(location: location, startTime: startTime, endTime: endTime)
      recordedLocations.append(recordedLocation)
    }

    return recordedLocations
  }
}

extension LocationsProvider {
  public func doesCoronaLocationsContain(location: CLLocation, date: Date) -> Bool {
    let newLocation = RecordedLocation(location: CoronaLocation(lat: location.coordinate.latitude,
                                                                lon: location.coordinate.longitude),
                                       startTime: date,
                                       endTime: date)

    guard let coronaLocations = getStoredCoronaLocations() else { return false }

    let matchingLocations = locationMatcher.matchLocations(userLocations: [newLocation], coronaLocations: coronaLocations)
    return !matchingLocations.isEmpty
  }
}
