//
//  AppDelegate.swift
//  code-orange
//
//  Created by Renen Elal on 15/03/2020.
//  Copyright © 2020 Renen Elal. All rights reserved.
//

import GoogleMaps
import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  let locationService = LocationService.shared
  let storageService = StorageService.shared

  public lazy var locationsProvider: LocationsProvider = {
    let locationsMatcher = LocationMatcher(matchingTimeThreshold: 30.minutes,
    mathcingDistanceThresholdInMeters: 30)
    return LocationsProvider(locationMatcher: locationsMatcher)
  }()
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    GMSServices.provideAPIKey("AIzaSyB57-_ZDUWdRSUi9ladkLO91d8wTlzpC8w")

//    if let launchOptions = launchOptions,
//      let isLocationKey = launchOptions[UIApplication.LaunchOptionsKey.location] as? Bool,
//      isLocationKey {
//      locationService.startUpdatingLocation()
//
//    }

    if !locationService.isUpdatingLocation {
      locationService.startUpdatingLocation()
    }

    return true
  }
}

private extension Double {
  var minutes: TimeInterval { return self * 60.0 }
}
