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

  private lazy var jsonDecoder: JSONDecoder = {
    let jsonDecoder = JSONDecoder()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
    return jsonDecoder
  }()

  private var infectedLocations = [COLocation]()

  init(session: URLSession = .shared) {
    self.session = session

    updateInfectedLocations()
  }

  private func notifyDownloadCompleted() {
    let downloadCompleted = Notification.Name("downloadCompleted")
    DispatchQueue.main.async {
      NotificationCenter.default.post(name: downloadCompleted, object: nil)
    }
  }
}

extension Communicator: DataFetcher {
  func updateInfectedLocations() {
    guard let url = URL(string: serverUrl) else { return }

    session.dataTask(with: url) { [weak self] data, response, error in
      if let data = data {
        do {
          guard let self = self else { return }
          let res = try self.jsonDecoder.decode(COLocations.self, from: data)
          self.infectedLocations = res.locations ?? []
          print("Downloaded \(self.infectedLocations.count) infected locations")
          // TODO: Replace with delegate pattern to notify data consumers
          self.notifyDownloadCompleted()
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
