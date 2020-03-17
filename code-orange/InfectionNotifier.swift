//
//  InfectionNotifier.swift
//  code-orange
//
//  Created by Alessandro Di Nepi on 17/03/2020.
//  Copyright © 2020 Renen Elal. All rights reserved.
//

import UIKit

class InfectionNotifier {
  static func notifyUser() {
    let center = UNUserNotificationCenter.current()

    center.removeAllDeliveredNotifications()
    center.removeAllPendingNotificationRequests()

    let request = createNotificationRequest()

    center.add(request) { error in
      if let error = error {
        print("Sending notification failed with error: ", error)
      }
    }
  }

  private static func createNotificationRequest() -> UNNotificationRequest {
    let content = UNMutableNotificationContent()

    content.title = "הסתובבת באיזור בו שהה חולה קורונה"
    content.body = "לחצו לראות עוד"
//    content.badge = NSNumber(value: 1)
    content.sound = UNNotificationSound.default

    // Add an attachment to the notification content
    if let url = Bundle.main.url(forResource: "dune", withExtension: "png") {
        if let attachment = try? UNNotificationAttachment(identifier: "dune",
                                                            url: url,
                                                            options: nil) {
            content.attachments = [attachment]
        }
    }
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
    let request = UNNotificationRequest(identifier: "infectionNotification",
                                        content: content,
                                        trigger: trigger)
    return request
  }
}
