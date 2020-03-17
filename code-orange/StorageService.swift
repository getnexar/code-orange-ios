//
//  LocationStorage.swift
//  code-orange
//
//  Created by Alessandro Di Nepi on 16/03/2020.
//  Copyright © 2020 Renen Elal. All rights reserved.
//

import Foundation
import CoreLocation
import CoreData

class StorageService {
  public static let shared = StorageService()

  private init() { }

  // MARK: - Core Data stack

  lazy var persistentContainer: NSPersistentContainer = {
      /*
       The persistent container for the application. This implementation
       creates and returns a container, having loaded the store for the
       application to it. This property is optional since there are legitimate
       error conditions that could cause the creation of the store to fail.
      */
      let container = NSPersistentContainer(name: "code_orange")
      container.loadPersistentStores(completionHandler: { (storeDescription, error) in
          if let error = error as NSError? {
              // TODO: Replace this implementation with code to handle the error appropriately.
              fatalError("Unresolved error \(error), \(error.userInfo)")
          }
      })
      return container
  }()

  // MARK: - Core Data Saving support

  func saveContext() {
      let context = persistentContainer.viewContext
      if context.hasChanges {
          do {
              try context.save()
          } catch {
              // TODO: Replace this implementation with code to handle the error appropriately.
              let nserror = error as NSError
              fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
          }
      }
  }
}

extension StorageService {
  func save(date: Date, location: CLLocation) {
    let managedContext = persistentContainer.viewContext

    let zone = Zone(context: managedContext)
    zone.setValue(location.coordinate.latitude, forKeyPath: "latitude")
    zone.setValue(location.coordinate.longitude, forKeyPath: "longitude")
    zone.setValue(date, forKeyPath: "dateEnter")

    do {
      try managedContext.save()
      print("Save zone at \(zone.latitude), \(zone.longitude)")
    }
    catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }

  func getUserLocations() -> [Zone] {
    let managedContext = persistentContainer.viewContext
    let request: NSFetchRequest<Zone> = Zone.fetchRequest()

    do {
      let zones = try managedContext.fetch(request)
      print("Found \(zones.count) user locations")

      return zones
    }  catch {
      // TODO: Replace this implementation with code to handle the error appropriately.
      let nserror = error as NSError
      fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
    }

    return []
  }
}
