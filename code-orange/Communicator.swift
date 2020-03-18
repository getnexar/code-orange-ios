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

protocol DataUploader {
  func shareInfectedLocations(_ locations: [COLocation])
}

class Communicator {
  private let session: URLSession
  private let serverUrl = "http://ec2-52-23-173-222.compute-1.amazonaws.com:8080/v1/events/covid-19/locations"
  private let serverExternalUrl = "http://ec2-52-23-173-222.compute-1.amazonaws.com:8080/v1/events/covid-19/external/il-moh-report"

  private lazy var jsonDecoder: JSONDecoder = {
    let jsonDecoder = JSONDecoder()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
    return jsonDecoder
  }()

  private lazy var jsonEncoder: JSONEncoder = {
    let jsonEncoder = JSONEncoder()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    jsonEncoder.dateEncodingStrategy = .formatted(dateFormatter)
    return jsonEncoder
  }()
  
  private var infectedLocations = [COLocation]()

  init(session: URLSession = .shared) {
    self.session = session
    updateInfectedLocations()
  }

  private func notifyConsumers() {
    let downloadCompleted = Notification.Name("downloadCompleted")
    DispatchQueue.main.async {
      NotificationCenter.default.post(name: downloadCompleted, object: nil)
    }
  }
}

extension Communicator: DataFetcher {
  func updateInfectedLocations() {
    guard let url = URL(string: serverUrl+"?patient_status=carrier&country=il") else { return }

    session.dataTask(with: url) { [weak self] data, response, error in
      if let data = data {
        do {
          guard let self = self else { return }
          let res = try self.jsonDecoder.decode(COLocations.self, from: data)
          self.infectedLocations = res.locations ?? []
          print("Downloaded \(self.infectedLocations.count) infected locations")
          self.notifyConsumers()
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

extension Communicator: DataUploader {
  
  private struct ServerStructure: Codable {
    var patientStatus: String
    var country: String
    var locations: [COLocation]
  }

  private struct MinistryOfHealthStructure: Codable {
    var patientCode: Int
    var locations: [COLocation]
  }

  func shareInfectedLocations(_ locations: [COLocation]) {
    guard !locations.isEmpty else { return }
    shareInfectedLocationsWithServer(locations)
    shareInfectedLocationsWithMinistryOfHealth(locations)
  }
  
  private func shareInfectedLocationsWithServer(_ locations: [COLocation]) {
    guard let url = URL(string: serverUrl) else { return }
    let structure = ServerStructure(patientStatus: "carrier", country: "il", locations: locations)
    guard let data = try? jsonEncoder.encode(structure) else {
      print("Error encoding locations to server")
      return
    }
    shareInfecedLocationsData(url: url, data: data)
  }
  
  private func shareInfectedLocationsWithMinistryOfHealth(_ locations: [COLocation]) {
    guard let url = URL(string: serverExternalUrl) else { return }
    let structure = MinistryOfHealthStructure(patientCode: 1500, locations: locations)
    
    guard let data = try? jsonEncoder.encode(structure) else {
      print("Error encoding locations to MoH")
      return
    }
    shareInfecedLocationsData(url: url, data: data)
  }

  private func shareInfecedLocationsData(url: URL, data: Data) {
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.httpBody = data
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    let task = session.dataTask(with: request)
    session.dataTask(with: request) { data, response, error in
      if let error = error {
        print("error sharing infected locations: \(error.localizedDescription)")
      }
      if let response = response {
        print("reponse to sharing infected locations: \(response)")
      }
    }
    task.resume()
  }
}
