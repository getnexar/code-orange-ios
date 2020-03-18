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
    return []
  }

  func updateInfectedLocations() {
    return
  }

  func getServerResults() -> [RecordedLocation]? {
    let stringData = getFromAPI()
    guard let data = stringData.data(using: .utf8, allowLossyConversion: false) else {
      return nil
    }

    guard let serverRecorededLocations = decode(data: data) else { return nil }
    let recordedLocations = serverRecorededLocations.compactMap { RecordedLocation(serverLocation: $0)}
    return recordedLocations
  }

  func decode(data: Data) -> [COLocation]? {
    let decoder = JSONDecoder()
    let decodedData: [String: [COLocation]]
    do {
      try decodedData = decoder.decode([String: [COLocation]].self, from: data)
    } catch {
      print("This Shouldn't happen")
      return nil
    }
    return decodedData["locations"]
  }

  // this is temp implementation, until we connect with the api
  private func getFromAPI() -> String {
    return StaticData.serverData
  }
}

extension String {
    func toJSON() -> Any? {
        guard let data = self.data(using: .utf8, allowLossyConversion: false) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    }
}
