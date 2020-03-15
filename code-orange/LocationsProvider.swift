//
//  LocationsProvider.swift
//  code-orange
//
//  Created by shani beracha on 15/03/2020.
//  Copyright © 2020 Renen Elal. All rights reserved.
//

import Foundation

class LocationsProvider {
  
  /*
   * returns two arrays:
   *   1. corona locations that do not match any user location
   *   2. user locations that were matched with corona locations
   */
  public static func getLocations() -> ([RecordedLocation], [RecordedLocation]) {
    guard let coronaLocations = getStoredCoronaLocations() else {
      return ([RecordedLocation](), [RecordedLocation]())
    }
    
    guard let userLocations = getStoredUserLocations() else {
      return (coronaLocations, [RecordedLocation]())
    }
    
    let matchingLocations = LocationMatcher.getMatchedLocations(of: coronaLocations, and: userLocations)
    let coronaNotMatchingLocations = coronaLocations.filter({ matchingLocations.contains($0) })
    
    return (coronaNotMatchingLocations, matchingLocations)
  }
  
  private static func getStoredCoronaLocations() -> [RecordedLocation]? {
    return nil
  }
  
  private static func getStoredUserLocations() -> [RecordedLocation]? {
    return nil
  }
}
