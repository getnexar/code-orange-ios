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
  
  public weak var locationProvider: LocationProvider?
  public weak var coordinatesProvider: CoordinatesProvider?

  private var coordinates = [CLLocationCoordinate2D]() {
    didSet {
      reloadCoordinates()
    }
  }
  private static let initialZoomLevel: Float = 7.5
  private static let defaultLocation = CLLocationCoordinate2D(latitude: 31.4013742, longitude: 35.2516147)

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
    let location = locationProvider?.currentLocation ?? MainViewController.defaultLocation
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
    // remove the next line when data becomes avaialble
    coordinatesProvider = mockedCoordinatesProvider
    coordinates = coordinatesProvider?.coordinates ?? []
    reloadCoordinates()
  }
  
  private func reloadCoordinates() {
    coordinates.forEach {
      let marker = GMSMarker()
      marker.position = $0
      marker.snippet = "Text"
      marker.map = mapView
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

extension MainViewController: CoordinatesProviderDelegate {
  func coordinatesProviderUpdated(_ sender: CoordinatesProvider) {
    coordinates = sender.coordinates
    reloadCoordinates()
  }
}

// remove this when real data becomes available
private let mockedCoordinatesProvider = MockedCoordinatesProvider()
private class MockedCoordinatesProvider: CoordinatesProvider {
  var delegate: CoordinatesProviderDelegate?
  var coordinates: [CLLocationCoordinate2D] { return SOME_MOCKED_COORDINATES }
  let SOME_MOCKED_COORDINATES = [
    CLLocationCoordinate2D(latitude: 32.848711, longitude: 35.064987),
    CLLocationCoordinate2D(latitude: 32.860300, longitude: 35.184660),
    CLLocationCoordinate2D(latitude: 31.783751, longitude: 35.192180)
  ]
}
