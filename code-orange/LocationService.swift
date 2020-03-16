//
//  LocationService.swift
//  code-orange
//
//  Created by Alessandro on 3/16/20.
//  Copyright © 2020 Renen Elal. All rights reserved.
//

import Foundation
import CoreLocation

class LocationService: NSObject {
  private let locationManager: CLLocationManager = {
    let locationManager = CLLocationManager()
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    locationManager.distanceFilter = 30
    return locationManager
  }()

  override private init() { super.init() }

  public static let shared = LocationService()

  public func startUpdatingLocation() {
    locationManager.requestAlwaysAuthorization()
    locationManager.startUpdatingLocation()
    locationManager.allowsBackgroundLocationUpdates = true
    locationManager.pausesLocationUpdatesAutomatically = false
    locationManager.delegate = self
  }
}

extension LocationService: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager,
                       didUpdateLocations locations: [CLLocation]){

    if let newLocation = locations.last {
      print("\(Date())) - (\(newLocation.coordinate.latitude), \(newLocation.coordinate.longitude))")
    }
  }

  func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
    print("Paused location updates")
  }
}
