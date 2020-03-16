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
  private var locationsProvider: LocationsProvider? {
    (UIApplication.shared.delegate as? AppDelegate)?.locationsProvider
  }
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
//    stackView.addArrangedSubview(changeStatusView)
    stackView.addArrangedSubview(mapView)
    return stackView
  }()
  
  private lazy var changeStatusView: ChangeStatueQuestionView = {
    let view = ChangeStatueQuestionView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.delegate = self
    return view
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
    button.setTitleColor(.nxGrey90, for: .normal)
    button.setTitleColor(.lightGray, for: .highlighted)
    button.tintColor = .nxGrey90
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
    button.setTitleColor(.nxGrey90, for: .normal)
    button.setTitleColor(.lightGray, for: .highlighted)
    button.tintColor = .nxGrey90
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
    button.setTitleColor(.nxGrey90, for: .normal)
    button.setTitleColor(.lightGray, for: .highlighted)
    button.tintColor = .nxGrey90
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
    button.setTitleColor(.nxPurple60, for: .normal)
    button.tintColor = .nxPurple60
    button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 8)
    button.addTarget(self, action: #selector(todayTapped), for: .touchUpInside)
    return button
  }()
  
  private lazy var separator: UIView = {
    let view = UIView()
    view.backgroundColor = .nxGrey30
    view.setAutoLayoutHeight(1)
    return view
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(mainStack)
    mainStack.pin(to: view, anchors: [.leading(0), .trailing(0), .top(28), .bottom(0)])
    // remove this
    view.addSubview(changeStatusView)
    changeStatusView.pin(to: view, anchors: [.bottom(0), .leading(0), .trailing(0)])
    getFreshLocations()
  }
  
  private func getFreshLocations() {
    locations = locationsProvider?.getLocations()
  }
  
  private func reloadCoordinates() {
    removeMarkers()
    loadMatchedLocations()
    loadOtherLocations()
  }
  
  private func removeMarkers() {
    markers.forEach { $0.map = nil }
    markers = []
  }
  
  private func loadMatchedLocations() {
    guard let locations = locations else { return }
    locations.matchedLocations.forEach {
      let marker = GMSMarker()
      let imageView = UIImageView(image: UIImage(named: "mapAnnotation"))
      imageView.tintColor = .nxOrange
      marker.iconView = imageView
      marker.position = CLLocationCoordinate2D(latitude: $0.location.lat, longitude: $0.location.lon)
      marker.map = mapView
      markers.append(marker)
    }
  }
  
  private func loadOtherLocations() {
    guard let locations = locations else { return }
    
    locations.otherLocations.suffix(100).forEach {
      let circleView = UIView()
      circleView.translatesAutoresizingMaskIntoConstraints = false
      circleView.backgroundColor = .nxPurple60
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

extension MainViewController: ChagneStatusViewDelegate {
  func statusChanged(to: StatusOption) {
    changeStatusView.removeFromSuperview()
    // bring on the next screen
  }
  
  func statusChangeDismissed() {
    changeStatusView.removeFromSuperview()
  }
  
  
}
