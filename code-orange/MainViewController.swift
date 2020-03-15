//
//  ViewController.swift
//  code-orange
//
//  Created by Renen Elal on 15/03/2020.
//  Copyright © 2020 Renen Elal. All rights reserved.
//

import UIKit
import GoogleMaps

class MainViewController: UIViewController {
  
  public weak var currentLocationProvider: CurrentLocationProvider?
  private var locationsProvider: LocationsProvider?
  private var markers = [GMSMarker]()

  private var locations: Locations? {
    didSet {
      reloadCoordinates()
    }
  }
  private static let initialZoomLevel: Float = 9
  private static let defaultLocation = CLLocationCoordinate2D(latitude: 32.086801, longitude: 34.789749)

  private lazy var mainStack: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.addArrangedSubview(titleStack)
    stackView.addArrangedSubview(separator)
    stackView.addArrangedSubview(subtitleStack)
    stackView.addArrangedSubview(timeScrollView)
    stackView.addArrangedSubview(mapView)
    return stackView
  }()
  
  private lazy var titleStack: UIStackView = {
    let stackView = UIStackView()
    stackView.spacing = 12
    stackView.axis = .horizontal
    stackView.isLayoutMarginsRelativeArrangement = true
    stackView.layoutMargins = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
    stackView.addArrangedSubview(statusButton)
    stackView.addArrangedSubview(UIView())
    stackView.addArrangedSubview(callEmergencyButton)
    return stackView
  }()
  
  private lazy var subtitleStack: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.spacing = 12
    stackView.isLayoutMarginsRelativeArrangement = true
    stackView.layoutMargins = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
    stackView.addArrangedSubview(monthButton)
    stackView.addArrangedSubview(UIView())
    stackView.addArrangedSubview(todayButton)
    return stackView
  }()
  
  private lazy var timeScrollView: UIView = {
    let view = UIView() // TODO: implement time scroller
    view.translatesAutoresizingMaskIntoConstraints = false
    view.setAutoLayoutHeight(0)
    return view
  }()
  
  private lazy var mapView: GMSMapView = {
    let location = currentLocationProvider?.currentLocation ?? MainViewController.defaultLocation
    let mapView = GMSMapView(frame: .zero, camera: GMSCameraPosition(target: location, zoom: MainViewController.initialZoomLevel))
    mapView.isMyLocationEnabled = true
    return mapView
  }()
  
  private lazy var statusButton: UIButton = {
    let button = UIButton()
    button.setAutoLayoutHeight(60)
    button.setTitle("Change Status", for: .normal)
    button.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
    button.setImage(UIImage(named: "outline"), for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.setTitleColor(.lightGray, for: .highlighted)
    button.tintColor = .black
    button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 8)
    button.addTarget(self, action: #selector(statusTapped), for: .touchUpInside)
    return button
  }()

  private lazy var callEmergencyButton: UIButton = {
    let button = UIButton()
    button.setAutoLayoutHeight(60)
    button.setTitle("101", for: .normal)
    button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
    button.setImage(UIImage(named: "phoneIcon"), for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.setTitleColor(.lightGray, for: .highlighted)
    button.tintColor = .black
    button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 8)
    button.addTarget(self, action: #selector(callEmergencyServiceTapped), for: .touchUpInside)
    return button
  }()

  private lazy var monthButton: UIButton = {
    let button = UIButton()
    button.setAutoLayoutHeight(60)
    button.setTitle("March 2020", for: .normal)
    button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
    button.setImage(UIImage(named: "calendar"), for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.setTitleColor(.lightGray, for: .highlighted)
    button.tintColor = .black
    button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 8)
    button.addTarget(self, action: #selector(monthTapped), for: .touchUpInside)
    return button
  }()

  private lazy var todayButton: UIButton = {
    let button = UIButton()
    button.setAutoLayoutHeight(60)
    button.setTitle("Today", for: .normal)
    button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
    button.setImage(UIImage(named: "refresh"), for: .normal)
    button.setTitleColor(.lightGray, for: .highlighted)
    button.setTitleColor(.purple, for: .normal)
    button.tintColor = .purple
    button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 8)
    button.addTarget(self, action: #selector(todayTapped), for: .touchUpInside)
    return button
  }()
  
  private lazy var separator: UIView = {
    let view = UIView()
    view.backgroundColor = .lightGray
    view.setAutoLayoutHeight(1)
    return view
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(mainStack)
    mainStack.pin(to: view, anchors: [.leading(0), .trailing(0), .top(28), .bottom(0)])
    loadLocations()
  }
  
  private func loadLocations() {
    let locationsMatcher = LocationMatcher(matchingTimeThreshold: 30.minutes,
                                           mathcingDistanceThresholdInMeters: 30)
    let locationsProvider = LocationsProvider(locationMatcher: locationsMatcher)
    self.locationsProvider = locationsProvider
    locations = locationsProvider.getLocations()
  }
  
  private func reloadCoordinates() {
    guard let locations = locations else { return }
    markers.forEach { $0.map = nil }
    locations.matchedLocations.forEach {
      let marker = GMSMarker()
      let imageView = UIImageView(image: UIImage(named: "mapAnnotation"))
      imageView.tintColor = .orange
      marker.iconView = imageView
      marker.position = CLLocationCoordinate2D(latitude: $0.location.lat, longitude: $0.location.lon)
      marker.map = mapView
      markers.append(marker)
    }
    locations.otherLocations.forEach {
      let circleView = UIView()
      circleView.translatesAutoresizingMaskIntoConstraints = false
      circleView.backgroundColor = .purple
      circleView.alpha = 0.4
      circleView.setAutoLayoutWidth(30)
      circleView.setSquareRatio()
      circleView.layer.masksToBounds = true
      circleView.layer.cornerRadius = 15
      let marker = GMSMarker()
      marker.iconView = circleView
      marker.position = CLLocationCoordinate2D(latitude: $0.location.lat, longitude: $0.location.lon)
      marker.map = mapView
      markers.append(marker)
    }
  }
  
  @objc private func statusTapped() {
    print("status tapped")
  }
  
  @objc private func callEmergencyServiceTapped() {
    print("call emergency tapped")
  }
  
  @objc private func monthTapped() {
    print("month tapped")
  }
  
  @objc private func todayTapped() {
    print("today tapped")
  }
}

private extension Double {
  var minutes: TimeInterval { return self * 60.0 }
}
