//
//  CodeOrangeMarker.swift
//  code-orange
//
//  Created by shani beracha on 18/03/2020.
//  Copyright © 2020 Renen Elal. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps

class CodeOrangeMarker: GMSMarker {
  var address: String?
  var startTime: Date
  var endTime: Date
  var type: MarkerType {
    didSet {
      if type == oldValue {
        return
      }
      
      setIcon()
    }
  }
  
  init(startTime: Date, endTime: Date, address: String?, type: MarkerType) {
    self.startTime = startTime
    self.endTime = endTime
    self.address = address
    self.type = type
    super.init()
    setIcon()
  }
  
  func setIcon() {
    icon = type.image
  }
  
  func select() {
    type = type.asSelected
  }
  
  func disSelect() {
    type = type.asNotSelected
  }
}

enum MarkerType {
  case infected
  case selectedInfected
  case matched
  case selectedMatched
  case currentUserLocation
  case pastUserLocation
}

extension MarkerType {
  var image: UIImage? {
    switch self {
    case .infected:
      return UIImage(named: "infectedLocation")
    case .selectedInfected:
      return UIImage(named: "selectedInfectedLocation")
    case .matched:
      return UIImage(named: "matchedLocation")
    case .selectedMatched:
      return UIImage(named: "selectedMatchedLocation")
    case .currentUserLocation:
      return UIImage(named: "currentUserLocation")
    case .pastUserLocation:
      return UIImage(named: "pastUserLocation")
    }
  }
  
  var asSelected: MarkerType {
    switch self {
    case .infected:
      return .selectedInfected
    case .selectedInfected:
      return self
    case .matched:
      return .selectedMatched
    case .selectedMatched:
      return self
    case .currentUserLocation:
      return self
    case .pastUserLocation:
      return self
    }
  }
  
  var asNotSelected: MarkerType {
    switch self {
    case .infected:
      return self
    case .selectedInfected:
      return .infected
    case .matched:
      return self
    case .selectedMatched:
      return .matched
    case .currentUserLocation:
      return self
    case .pastUserLocation:
      return self
    }
  }
}


