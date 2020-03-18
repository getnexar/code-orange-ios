//
//  Communicator.swift
//  code-orange
//
//  Created by shani beracha on 16/03/2020.
//  Copyright © 2020 Renen Elal. All rights reserved.
//

import Foundation

class Communicator {
  func getServerResults() -> [RecordedLocation]? {
    let stringData = getFromAPI()
    guard let data = stringData.data(using: .utf8, allowLossyConversion: false) else {
      return nil
    }
    
    guard let serverRecorededLocations = decode(data: data) else { return nil }
    let recordedLocations = serverRecorededLocations.compactMap { RecordedLocation(serverLocation: $0)}
    return recordedLocations
  }
  
  // TEMP - remove this
  func getUserData() -> [RecordedLocation]? {
    let stringData = getFromStorage()
    guard let data = stringData.data(using: .utf8, allowLossyConversion: false) else {
      return nil
    }
    
    guard let serverRecorededLocations = decode(data: data) else { return nil }
    let recordedLocations = serverRecorededLocations.compactMap { RecordedLocation(serverLocation: $0)}
    return recordedLocations
  }
  
  func decode(data: Data) -> [ServerRecordedLocation]? {
    let decoder = JSONDecoder()
    let decodedData: [String: [ServerRecordedLocation]]
    do {
      try decodedData = decoder.decode([String: [ServerRecordedLocation]].self, from: data)
    } catch {
      print("This Shouldn't happen: \(error)")
      return nil
    }
    return decodedData["locations"]
  }
  
  // this is temp implementation, until we connect with the api
  private func getFromAPI() -> String {
//    return StaticData.serverData
    return StaticData.newShortData
  }
  
  private func getFromStorage() -> String {
    return StaticData.userData
  }
}

extension String {
    func toJSON() -> Any? {
        guard let data = self.data(using: .utf8, allowLossyConversion: false) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    }
}
