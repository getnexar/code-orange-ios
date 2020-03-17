//
//  LocationService.swift
//  code-orange
//
//  Created by Alessandro on 3/16/20.
//  Copyright © 2020 Renen Elal. All rights reserved.
//

import UIKit
import CoreLocation

class LocationService: NSObject {
  private var locationsProvider: LocationsProvider? {
    (UIApplication.shared.delegate as? AppDelegate)?.locationsProvider
  }

  private let locationManager: CLLocationManager = {
    let locationManager = CLLocationManager()
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    locationManager.distanceFilter = 30
    return locationManager
  }()

  override private init() { super.init() }

  public static let shared = LocationService()

  public var isUpdatingLocation = false

  public func startUpdatingLocation() {
    guard CLLocationManager.locationServicesEnabled(), !isUpdatingLocation else { return }

    locationManager.requestAlwaysAuthorization()
    locationManager.startUpdatingLocation()
    locationManager.allowsBackgroundLocationUpdates = true
    locationManager.pausesLocationUpdatesAutomatically = false
    locationManager.delegate = self
    isUpdatingLocation = true
    print("Start updating location")
  }

  public func stopUpdatingLocation() {
    guard isUpdatingLocation else { return }

    locationManager.stopUpdatingLocation()
    isUpdatingLocation = false
    print("Stop updating location")
  }
}

extension LocationService: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager,
                       didUpdateLocations locations: [CLLocation]){

    guard let newLocation = locations.last else { return }

    print("Location update \(Date())) - (\(newLocation.coordinate.latitude), \(newLocation.coordinate.longitude))")

    let date = Date()

    if locationsProvider?.doesCoronaLocationsContain(location: newLocation, date: date) ?? false {
      print("Found infected locations at \(newLocation.coordinate.latitude), \(newLocation.coordinate.longitude)")
      InfectionNotifier.notifyUser()
    }

    StorageService.shared.save(date: Date(), location: newLocation)
  }

  func locationManager(_ manager: CLLocationManager,
                       didChangeAuthorization status: CLAuthorizationStatus) {
    if status == .authorizedAlways || status == .authorizedWhenInUse {
      print("Permissions OK")
      startUpdatingLocation()
    } else {
      print("Permissions KO")
      stopUpdatingLocation()
    }
  }

  func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
    print("Paused location updates")
  }
}
