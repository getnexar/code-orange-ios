//
//  ViewController.swift
//  code-orange
//
//  Created by Renen Elal on 15/03/2020.
//  Copyright © 2020 Renen Elal. All rights reserved.
//

import UIKit
import GoogleMaps

protocol CurrentLocationProvider: class {
  var currentLocation: CLLocationCoordinate2D { get }
}

class ViewController: UIViewController {
  
  public weak var locationProvider: CurrentLocationProvider?

  private lazy var titleStack: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.addArrangedSubview(statusButton)
    stackView.addArrangedSubview(UIView())
    stackView.addArrangedSubview(callEmergencyButton)
    return stackView
  }()
  
  private lazy var subtitleStack: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    return stackView
  }()
  
  private lazy var timeScrollView: UIView = {
    let view = UIView() // TODO: implement time scroller
    view.translatesAutoresizingMaskIntoConstraints = false
    view.setAutoLayoutHeight(0)
    return view
  }()
  
  private lazy var mapView: GMSMapView = {
    let location = locationProvider?.currentLocation ?? CLLocationCoordinate2D(latitude: 0, longitude: 0)
    let mapView = GMSMapView(frame: .zero, camera: GMSCameraPosition(target: location, zoom: 1.0))
    
    return mapView
  }()
  
  
  private lazy var statusButton: UIButton = {
    let button = UIButton()
    
    return button
  }()

  private lazy var callEmergencyButton: UIButton = {
    let button = UIButton()
    
    return button
  }()

  private lazy var monthButton: UIButton = {
    let button = UIButton()
    
    return button
  }()

  private lazy var todayButton: UIButton = {
    let button = UIButton()
    
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }


}

