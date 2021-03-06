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
  
  enum DrawerContent: Equatable {
    case none
    case changeStatusView
    case visitedLocationsPanel
    case infectedLocationPanel
    case permissions(minimized: Bool)
  }
  
  public weak var currentLocationProvider: CurrentLocationProvider?
  private var locationsProvider: LocationsProvider? {
    (UIApplication.shared.delegate as? AppDelegate)?.locationsProvider
  }
  private var dataUploader: DataUploader? {
    (UIApplication.shared.delegate as? AppDelegate)?.communicator as DataUploader?
  }
  private var markers = [GMSMarker]()
  private var matchedLocationsToMarkers: [CLLocationCoordinate2D: CodeOrangeMarker]?
  private var visitedLocationsPanel: VisitedLocationsPanel?

  private var locations: Locations? {
    didSet {
      reloadCoordinates()
    }
  }
  private static let initialZoomLevel: Float = 9
  private static let defaultLocation = CLLocationCoordinate2D(latitude: 32.086801, longitude: 34.789749)
  private var shareLocationView : ShareLocationView?
  private var selectedMarker: CodeOrangeMarker? {
    didSet {
      oldValue?.disSelect()
      // we do not want to dismiss the change status view by the map
      guard drawerContent != .changeStatusView, let marker = selectedMarker else {
        return
      }
      switch marker.type {
      case .currentUserLocation, .pastUserLocation, .selectedMatched, .selectedInfected:
        // these types should not be making changes to selection
        return
      case .matched:
        selectedMarker?.select()
        if drawerContent != .visitedLocationsPanel {
          drawerContent = .visitedLocationsPanel
        }
      case .infected:
        selectedMarker?.select()
        drawerContent = .infectedLocationPanel
      }
    }
  }
  
  private var drawerContent: DrawerContent = .none {
    didSet {
      if oldValue != drawerContent {
        switch oldValue {
        case .none, .changeStatusView: // dismiss drawer
          print("old content doesn't require dismiss action dismissed")
        case .infectedLocationPanel:
          print("what should I do?")
        case .visitedLocationsPanel:
          dismissMatchedLocationsPanel()
        case .permissions(_):
          print("what should I do?")
          }
        }
    
      var shouldDismissDrawer = oldValue != .none && oldValue == drawerContent
      let action: (() -> ())?
      switch drawerContent {
      case .none: // dismiss drawer
        shouldDismissDrawer = true
        action = nil
      case .changeStatusView:
        action = displayChangeStatusView
      case .infectedLocationPanel:
        action = self.displayInfectedLocationPanel
      case .visitedLocationsPanel:
        action = displayMatchedLocationsPanel
      case .permissions:
        action = displayLocationPermissionPanel
      }
      
      switchDrawerCotent(shouldDismissDrawer: shouldDismissDrawer, switchingContentAction: action)
    }
  }
  
  private func switchDrawerCotent(shouldDismissDrawer: Bool, switchingContentAction: (() -> ())? = nil) {
    if shouldDismissDrawer {
      dismissDrawer(completion: switchingContentAction)
    } else {
      switchingContentAction?()
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
    mapView.delegate = self
    do {
      if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json") {
        mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
      } else {
        print("Unable to find style.json")
      }
    } catch {
      print("map style failed to load. \(error)")
    }
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
    NotificationCenter.default.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.didBecomeActiveNotification, object: nil)
    
    view.backgroundColor = .white
    view.addSubview(mainStack)
    view.addSubview(drawerView)
    mainStack.pin(to: view, anchors: [.leading(0), .trailing(0), .top(28), .bottom(0)])
    drawerView.pin(to: view, anchors: [.leading(0), .trailing(0), .bottom(-24)])

    NotificationCenter.default.addObserver(self,
                                           selector: #selector(getFreshLocations),
                                           name: NSNotification.Name("downloadCompleted"),
                                           object: nil)
  }
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    refreshLocation()
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
  
  @objc private func getFreshLocations() {
    locations = locationsProvider?.getLocations()
  }
  
  private func reloadCoordinates() {
    removeMarkers()
    loadMatchedLocations()
    loadInfectedLocations()
  }
  
  private func removeMarkers() {
    markers.forEach { $0.map = nil }
    markers = []
  }
  
  private func loadMatchedLocations() {
    guard let locations = locations else { return }
    guard !locations.matchedLocations.isEmpty else {
      matchedLocationsToMarkers = nil
      return
    }
    
    matchedLocationsToMarkers = [CLLocationCoordinate2D: CodeOrangeMarker]()
    locations.matchedLocations.forEach { matchedLocation in
      addInfectedMatchedMarker(infectedLocation: matchedLocation.infectedLocation)
      addUserMatchedMarker(userLocation: matchedLocation.userLocation)
    }
    
    drawerContent = .visitedLocationsPanel
  }
  
  private func addInfectedMatchedMarker(infectedLocation: COLocation) {
    let marker = addCircleMarker(recordedLocation: infectedLocation, type: .matched)
    matchedLocationsToMarkers?[infectedLocation.coordinates] = marker
  }
  
  private func addUserMatchedMarker(userLocation: COLocation) {
    let marker = CodeOrangeMarker(startTime: userLocation.startTime, endTime: userLocation.endTime, address: userLocation.name, type: .pastUserLocation)
    marker.position = CLLocationCoordinate2D(latitude: userLocation.lat, longitude: userLocation.lon)
    marker.map = mapView
    markers.append(marker)
  }
  
  private func loadInfectedLocations() {
    guard let locations = locations else { return }
    
    locations.otherLocations.forEach { infectedLocation in
      addCircleMarker(recordedLocation: infectedLocation, type: .infected)
    }
  }
    
  @discardableResult private func addCircleMarker(recordedLocation: COLocation, type: MarkerType) -> CodeOrangeMarker {
    let marker = CodeOrangeMarker(startTime: recordedLocation.startTime,
                                  endTime: recordedLocation.endTime,
                                  address: recordedLocation.name,
                                  type: type)
    marker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
    marker.position = CLLocationCoordinate2D(latitude: recordedLocation.lat, longitude: recordedLocation.lon)
    marker.map = mapView
    markers.append(marker)
    return marker
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
  
  private func displayMatchedLocationsPanel() {
    guard visitedLocationsPanel == nil else { return }
    let matchedLocations = self.locations?.matchedLocations ?? []
    guard let visitedLocationsPanel = VisitedLocationsPanel(locations: matchedLocations) else { return }
    self.visitedLocationsPanel = visitedLocationsPanel
    visitedLocationsPanel.delegate = self
    visitedLocationsPanel.translatesAutoresizingMaskIntoConstraints = false
    drawerView.contentView = visitedLocationsPanel
    showDrawer()
  }
  
  func dismissMatchedLocationsPanel() {
    visitedLocationsPanel = nil
  }
  
  private func displayLocationPermissionPanel() {
    guard case let .permissions(minimized) = drawerContent else {
      return
    }
    if let existingPanel = drawerView.contentView as? LocationPermissionPanel {
      UIView.animate(withDuration: 0.4) {
        existingPanel.isMinimized = minimized
      }
      showDrawer()
      return
    }
    
    let panel = LocationPermissionPanel()
    panel.translatesAutoresizingMaskIntoConstraints = false
    panel.delegate = self
    panel.isMinimized = minimized
    drawerView.contentView = panel
    showDrawer()
  }
  
  private func showDrawer() {
    self.drawerView.isHidden = false
  }
  
  private func dismissDrawer(completion: (() -> ())? = nil) {
    UIView.animate(withDuration: 0.4, animations: {
      self.drawerView.isHidden = true
    }) { _ in
      completion?()
    }
  }
  
  private func presentShareLocationScreen() {
    let shareLocationView = ShareLocationView()
    shareLocationView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(shareLocationView)
    shareLocationView.fillSuperview()
    shareLocationView.delegate = self
    self.shareLocationView = shareLocationView
  }
  
  private func refreshLocation() {
    switch CLLocationManager.authorizationStatus() {
    case .authorizedAlways:
      getFreshLocations()
      mapView.isMyLocationEnabled = true
      if case .permissions = drawerContent {
        drawerContent = .none
      }
    case .notDetermined:
      mapView.isMyLocationEnabled = false
      drawerContent = .permissions(minimized: false)
    case .authorizedWhenInUse, .denied, .restricted:
      mapView.isMyLocationEnabled = false
      drawerContent = .permissions(minimized: true)
    @unknown default:
      return
    }
  }
  
  @objc private func appMovedToForeground() {
    refreshLocation()
  }
}

extension MainViewController: ChagneStatusViewDelegate {
  func statusChanged(to status: StatusOption) {
    drawerContent = .none
    switch status {
    case .infected:
      presentShareLocationScreen()
    default:
      print("We do not report on status \(status.description)")
    }
  }
  
  func statusChangeDismissed() {
    drawerContent = .none
  }
}

extension MainViewController: VisitedLocationsPanelDelegate {
  func visitedLocationsDidSelectLocation(_ location: CLLocationCoordinate2D) {
    selectedMarker = matchedLocationsToMarkers?[location]
    let coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
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

extension MainViewController: LocationPermissionPanelDelegate {
  func locationPermissionSwitchToSettings() {
    guard CLLocationManager.authorizationStatus() != .notDetermined else {
      drawerContent = .permissions(minimized: false)
      return
    }
    guard let url = URL(string:UIApplication.openSettingsURLString) else { return}
    UIApplication.shared.open(url)
  }
  
  func locationPermissionAuthorized() {
    (UIApplication.shared.delegate as? AppDelegate)?.startLocationTracking()
    drawerContent = .none
  }
  
  func locationPermissionNotAuthorized() {
    drawerContent = .permissions(minimized: true)
  }
  
  func locationPermissionMaximized() {
    // TODO: apply dark shade on view
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

extension MainViewController: ShareLocationViewDelegate {
  func shareLocationsDismissed(_ sender: UIView) {
    sender.removeFromSuperview()
    shareLocationView = nil
  }
  
  func shareLocationApproved(_ sender: UIView, code: String) {
    sender.removeFromSuperview()
    guard let dataUploader = dataUploader, let matchedLocations = self.locations?.matchedLocations else {
      return
    }
    let locations = matchedLocations.compactMap { $0.userLocation }
    dataUploader.shareInfectedLocations(locations)
  }
}

extension MainViewController: GMSMapViewDelegate {
  func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
    guard let selectedMarker = marker as? CodeOrangeMarker else { return false }
    switch selectedMarker.type {
    case .matched, .infected:
      self.selectedMarker = selectedMarker
    case .pastUserLocation, .currentUserLocation, .selectedInfected, .selectedMatched:
      return false
    }
    self.selectedMarker = selectedMarker
    return false
  }
  
  func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
    drawerContent = .none
    selectedMarker = nil
  }
  
  func displayInfectedLocationPanel() {
    guard let selectedMarker = selectedMarker else {
      print("No selected marker")
        return
    }
    
    let infectedLocationPanel = InfectedLocationView(startTime: selectedMarker.startTime, endTime: selectedMarker.endTime, address: selectedMarker.address)
    infectedLocationPanel.translatesAutoresizingMaskIntoConstraints = false
    drawerView.contentView = infectedLocationPanel
    showDrawer()
  }
}
