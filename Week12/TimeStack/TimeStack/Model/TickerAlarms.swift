//
//  TickerAlarms.swift
//  TimeStack
//
//  Created by Bill Matthews on 2020-08-16.
//  Copyright © 2020 Bill Matthews. All rights reserved.
//

import Foundation
import UserNotifications

struct TickerAlarm: Identifiable, Equatable, Codable {
  var id: UUID
  let title: String
  let body: String
  let targetTime: TimeInterval
  
  
  func schedule(for timerID: UUID) {
    let alarmContent = UNMutableNotificationContent()
    let alarmID = id.uuidString
    alarmContent.title = title
    alarmContent.body = body
    alarmContent.categoryIdentifier = "alarm"
    alarmContent.userInfo = ["id": timerID]
    alarmContent.sound = UNNotificationSound.default
    
    let alarmTrigger = UNTimeIntervalNotificationTrigger(timeInterval: targetTime, repeats: false)
    
    let notificationRequest = UNNotificationRequest(identifier: alarmID, content: alarmContent, trigger: alarmTrigger)
    UNUserNotificationCenter.current().add(notificationRequest) { _ in
      print("Notification request in \(self.targetTime.compoundTimeString()) seconds for: \(self.body)")
    }
  }
    
  func cancel() {
    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id.uuidString])
    print("Cancelling notification for: \(body)")
  }
}

