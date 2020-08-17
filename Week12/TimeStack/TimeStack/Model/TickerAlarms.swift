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
  let targetTime: TimeInterval
  
  func schedule() {
    let alarmContent = UNMutableNotificationContent()
    let alarmID = id.uuidString
    alarmContent.title = title
    alarmContent.categoryIdentifier = "alarm"
    alarmContent.sound = UNNotificationSound.default
    
    let alarmTrigger = UNTimeIntervalNotificationTrigger(timeInterval: targetTime, repeats: false)
    
    let notificationRequest = UNNotificationRequest(identifier: alarmID, content: alarmContent, trigger: alarmTrigger)
    UNUserNotificationCenter.current().add(notificationRequest) { _ in
      self.report("\(self.title) scheduled in \(self.targetTime.compoundTimeString())")
    }
  }
    
  func cancel() {
    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id.uuidString])
    report("Cancelling \(title)")
  }
  
  private func report(_ string: String){
    print("🔔 Alarm: \(string)")
  }
}

