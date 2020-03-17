//
//  ViewController.swift
//  code-orange
//
//  Created by Renen Elal on 15/03/2020.
//  Copyright © 2020 Renen Elal. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps

class MainViewController: UIViewController {
  
  enum DrawerContent {
    case none
    case changeStatusView
    case visitedLocationsPanel
  }
  
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
  
  private var drawerContent: DrawerContent = .none {
    didSet {
      switch drawerContent {
      case .none: // dismiss drawer
        dismissDrawer()
      case .changeStatusView:
        dismissDrawer() {
          self.displayChangeStatusView()
        }
      case .visitedLocationsPanel:
        dismissDrawer() {
          self.displayMatchedLocationsPanel(self.locations?.matchedLocations ?? [])
        }
      }
    }
  }

  private lazy var mainStack: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.addArrangedSubview(titleStack)
    stackView.addArrangedSubview(separator)
    stackView.addArrangedSubview(subtitleStack)
    stackView.addArrangedSubview(timeScrollView)
    stackView.addArrangedSubview(mapView)
    stackView.addArrangedSubview(drawerView)
    if #available(iOS 11.0, *) {
      stackView.setCustomSpacing(-drawerView.layer.cornerRadius, after: mapView)
    }
    return stackView
  }()
  
  private lazy var titleStack: UIStackView = {
    let stackView = UIStackView()
    stackView.spacing = 12
    stackView.axis = .horizontal
    stackView.isLayoutMarginsRelativeArrangement = true
    stackView.layoutMargins = UIEdgeInsets(top: 0, left: 24, bottom: 24, right: 24)
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
    button.setTitle("שנה סטטוס", for: .normal)
    button.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
    button.setImage(UIImage(named: "outline"), for: .normal)
    button.setTitleColor(.nxGrey90, for: .normal)
    button.setTitleColor(.lightGray, for: .highlighted)
    button.tintColor = .nxGrey90
    button.imageEdgeInsets = getLocalizedInsets(top: 0, left: -8, bottom: 0, right: 8)
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
    button.imageEdgeInsets = getLocalizedInsets(top: 0, left: -8, bottom: 0, right: 8)
    button.addTarget(self, action: #selector(callEmergencyServiceTapped), for: .touchUpInside)
    return button
  }()

  private lazy var monthButton: UIButton = {
    let button = UIButton()
    button.setAutoLayoutHeight(60)
    button.setTitle("מרץ 2020", for: .normal)
    button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
    button.setImage(UIImage(named: "calendar"), for: .normal)
    button.setTitleColor(.nxGrey90, for: .normal)
    button.setTitleColor(.lightGray, for: .highlighted)
    button.tintColor = .nxGrey90
    button.imageEdgeInsets = getLocalizedInsets(top: 0, left: -8, bottom: 0, right: 8)
    button.addTarget(self, action: #selector(monthTapped), for: .touchUpInside)
    return button
  }()

  private lazy var todayButton: UIButton = {
    let button = UIButton()
    button.setAutoLayoutHeight(60)
    button.setTitle("היום", for: .normal)
    button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
    button.setImage(UIImage(named: "refresh"), for: .normal)
    button.setTitleColor(.lightGray, for: .highlighted)
    button.setTitleColor(.nxPurple60, for: .normal)
    button.tintColor = .nxPurple60
    button.imageEdgeInsets = getLocalizedInsets(top: 0, left: -8, bottom: 0, right: 8)
    button.addTarget(self, action: #selector(todayTapped), for: .touchUpInside)
    return button
  }()
  
  private lazy var separator: UIView = {
    let view = UIView()
    view.backgroundColor = .nxGrey30
    view.setAutoLayoutHeight(1)
    return view
  }()

  private lazy var drawerView: DrawerView = {
    let drawerView = DrawerView()
    drawerView.translatesAutoresizingMaskIntoConstraints = false
    drawerView.isHidden = true
    return drawerView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    view.addSubview(mainStack)
    mainStack.pin(to: view, anchors: [.leading(0), .trailing(0), .top(28), .bottom(-24)])
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    getFreshLocations()
  }
  
  private func getLocalizedInsets(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) -> UIEdgeInsets {
    let insets: UIEdgeInsets
    if UIView.userInterfaceLayoutDirection(for: self.view.semanticContentAttribute) == .rightToLeft {
      insets = UIEdgeInsets(top: top, left: right, bottom: bottom, right: left)
    } else {
      insets = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
    }
    
    return insets
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
    locations.matchedLocations.forEach { matchedLocation in
      addInfectedMatchedMarker(infectedLocation: matchedLocation.infectedLocation)
      addUserMatchedMarker(userLocation: matchedLocation.userLocation)
    }
    guard !locations.matchedLocations.isEmpty else { return }
    drawerContent = .visitedLocationsPanel
  }
  
  private func addInfectedMatchedMarker(infectedLocation: RecordedLocation) {
    addCircleMarker(lat: infectedLocation.location.lat, lon: infectedLocation.location.lon, color: .orange)
  }
  
  private func addUserMatchedMarker(userLocation: RecordedLocation) {
    let marker = GMSMarker()
    let imageView = UIImageView(image: UIImage(named: "pastUserLocation"))
    imageView.tintColor = .nxPurple60
    marker.iconView = imageView
    marker.position = CLLocationCoordinate2D(latitude: userLocation.location.lat, longitude: userLocation.location.lon)
    marker.map = mapView
    markers.append(marker)
  }
  
  private func loadOtherLocations() {
    guard let locations = locations else { return }
    
    locations.otherLocations.suffix(100).forEach { infectedLocation in
      addCircleMarker(lat: infectedLocation.location.lat, lon: infectedLocation.location.lon, color: .nxPurple60)
    }
  }
  
  private func addCircleMarker(lat: Double, lon: Double, color: UIColor) {
    let circleView = CircleMarkerView(color: color)
    let marker = GMSMarker()
    marker.iconView = circleView
    marker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
    marker.position = CLLocationCoordinate2D(latitude: lat, longitude: lon)
    marker.map = mapView
    markers.append(marker)
  }
  
  @objc private func statusTapped() {
    print("status tapped")
    drawerContent = .changeStatusView
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
  
  private func displayChangeStatusView() {
    let changeStatusView = ChangeStatueView()
    changeStatusView.delegate = self
    changeStatusView.translatesAutoresizingMaskIntoConstraints = false
    drawerView.contentView = changeStatusView
    showDrawer()
  }
  
  private func displayMatchedLocationsPanel(_ matchedLocations: [MatchedLocation]) {
    guard let visitedLocationsPanel = VisitedLocationsPanel(locations: matchedLocations) else { return }
    visitedLocationsPanel.delegate = self
    visitedLocationsPanel.translatesAutoresizingMaskIntoConstraints = false
    drawerView.contentView = visitedLocationsPanel
    showDrawer()
  }
  
  private func showDrawer() {
    guard drawerView.isHidden else {
      return
    }
    UIView.animate(withDuration: 0.4) {
      self.drawerView.isHidden = false
    }
  }
  
  private func dismissDrawer(completion: (() -> ())? = nil) {
    guard !drawerView.isHidden else {
      completion?()
      return
    }
    UIView.animate(withDuration: 0.4, animations: {
      self.drawerView.isHidden = true
    }) { _ in
      completion?()
    }
  }
}

extension MainViewController: ChagneStatusViewDelegate {
  func statusChanged(to: StatusOption) {
    drawerContent = .none
    // bring on the next screen
  }
  
  func statusChangeDismissed() {
    drawerContent = .none
  }
}

extension MainViewController: VisitedLocationsPanelDelegate {
  func visitedLocationsDidSelectLocation(_ location: MatchedLocation) {
    let coordinate = CLLocationCoordinate2D(latitude: location.userLocation.location.lat, longitude: location.userLocation.location.lon)
    let cameraUpdate = GMSCameraUpdate.setTarget(coordinate, zoom: 16)
    mapView.animate(with: cameraUpdate)
  }
  
  func visitedLocationsPanelCallEmergency() {
    drawerContent = .none
  }
  
  func visitedLocationsPanelOpenHealthAdministrationWebsite() {
    drawerContent = .none
  }
}

class CircleMarkerView: UIView {
  init(color: UIColor) {
    super.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false
    backgroundColor = color
    alpha = 0.4
    setAutoLayoutWidth(30)
    setSquareRatio()
    layer.masksToBounds = true
    cornerRadius = 15
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
