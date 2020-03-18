//
//  Communicator.swift
//  code-orange
//
//  Created by shani beracha on 16/03/2020.
//  Copyright © 2020 Renen Elal. All rights reserved.
//

import Foundation

protocol DataFetcher {
  func updateInfectedLocations()
  func getInfectedLocations() -> [COLocation]
}

class Communicator {
  private let session: URLSession
  private let serverUrl = "http://ec2-52-23-173-222.compute-1.amazonaws.com:8080/v1/events/covid-19/locations?patient_status=carrier&country=il"

  private var infectedLocations = [COLocation]()

  init(session: URLSession = .shared) {
    self.session = session

    updateInfectedLocations()
  }
}

extension Communicator: DataFetcher {
  func updateInfectedLocations() {
    guard let url = URL(string: serverUrl) else { return }

    session.dataTask(with: url) { [weak self] data, response, error in
      if let data = data {
        do {
          let res = try JSONDecoder().decode(COLocations.self, from: data)
          self?.infectedLocations = res.locations ?? []
        } catch let error {
          print("Fetching data failed with error: \(error)")
        }
      }
    }.resume()
  }

  func getInfectedLocations() -> [COLocation] {
    return infectedLocations
  }
}
