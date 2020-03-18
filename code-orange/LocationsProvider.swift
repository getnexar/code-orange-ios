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
  var otherLocations: [COLocation]
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

  private func getStoredCoronaLocations() -> [COLocation]? {
    return dataFetcher.getInfectedLocations()
  }
  
  private func getStoredUserLocations() -> [COLocation]? {
    let zones = StorageService.shared.getUserLocations()
    var userLocations = [COLocation]()

    zones.forEach { zone in
      let location = COLocation(lat: zone.latitude,
                                lon: zone.longitude,
                                startTime: zone.startTime ?? Date(timeIntervalSince1970: 0.0),
                                endTime: zone.endTime ?? Date(timeIntervalSince1970: 0.0),
                                radius: 0.0,
                                name: "",
                                comments: "")
      userLocations.append(location)
    }

    return userLocations
  }
}

extension LocationsProvider {
  public func doesCoronaLocationsContain(location: CLLocation, date: Date) -> Bool {
    let startTime = Calendar.current.date(byAdding: .minute, value: -15, to: date)
    let endTime = Calendar.current.date(byAdding: .minute, value: 15, to: date)
    let newLocation = COLocation(lat: location.coordinate.latitude,
                                 lon: location.coordinate.longitude,
                                 startTime: startTime ?? Date(timeIntervalSince1970: 0.0),
                                 endTime: endTime ?? Date(timeIntervalSince1970: 0.0),
                                 radius: 0.0,
                                 name: "",
                                 comments: "")

    guard let coronaLocations = getStoredCoronaLocations() else { return false }

    let matchingLocations = locationMatcher.matchLocations(userLocations: [newLocation], coronaLocations: coronaLocations)
    return !matchingLocations.isEmpty
  }
}
