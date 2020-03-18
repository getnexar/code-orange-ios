//
//  CommunicatorMock.swift
//  code-orangeTests
//
//  Created by Alessandro Di Nepi on 17/03/2020.
//  Copyright © 2020 Renen Elal. All rights reserved.
//

import Foundation
@testable import code_orange

class CommunicatorMock: DataFetcher {
  func getInfectedLocations() -> [COLocation] {
    let dateFormatter = ISO8601DateFormatter()
    let startTime = dateFormatter.date(from: "2020-03-18T09:00:00+02:00") ?? Date(timeIntervalSince1970: 0.0)
    let endTime = dateFormatter.date(from: "2020-03-18T012:00:00+02:00") ?? Date(timeIntervalSince1970: 0.0)

    return [
      COLocation(lat: 32.05915, lon: 34.78358, startTime: startTime, endTime: endTime, radius: 50.0, name: "Test location 1", comments: ""),
      COLocation(lat: 32.06167, lon: 34.78488, startTime: startTime, endTime: endTime, radius: 50.0, name: "Test location 2", comments: ""),
    ]
  }

  func updateInfectedLocations() {
    return
  }
}
