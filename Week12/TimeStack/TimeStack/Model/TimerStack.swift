//
//  TimerStack.swift
//  TimerStack
//
//  Created by Bill Matthews on 2020-08-11.
//  Copyright © 2020 Bill Matthews. All rights reserved.
//

import Foundation
import Combine

typealias CompoundTime = (hours: Int, minutes: Int, seconds: Int)

class TimerStack: ObservableObject {
  
  enum TimerState {
    case pending, inProgress, done
  }
  
  enum StackState {
    case solo, first, last, stacked
  }
  
  static let previewList: [TimerStack] = [
    TimerStack(duration: 10),
    TimerStack(name: "Potatoes", duration: 60),
    TimerStack(duration: 30)
  ]
  
  private let id: UUID
  private var activeTimer: Timer? //Timer for completion
  
  var name: String?
  
  private var duration: TimeInterval
  private var elapsed: TimeInterval = 0 {
    didSet {
      if elapsed < duration {
        remaining = duration - elapsed
      } else {
        remaining = 0
        timerState = .done
      }
    }
  }
  
  @Published var remaining: TimeInterval
  
  private(set) var timerState: TimerState = .pending {
    didSet {
      switch timerState {
      case .pending:
        print("Stopped timer")
        stop()
      case .inProgress:
        print("Started timer")
        start()
      case .done:
        print("Timer completed")
      }
    }
  }
  private(set) var stackState: StackState = .solo
  
  var isInProgress: Bool {
    timerState == .inProgress
  }
  
  //MARK: - Initializers
  
  init(id: UUID = UUID(), name: String? = nil, duration: TimeInterval) {
    self.id = id
    self.name = name
    self.duration = duration
    self.remaining = duration
    print("Initializing \(id.uuidString) (\(name ?? "Unnamed")) - \(duration.compoundTimeString())")
  }
  
  deinit {
    print("Deinitializing \(id.uuidString) (\(name ?? "Unnamed"))")
  }
  
  //MARK: - Public functions
  
  private func start() {
    //TODO: Consider completion handlers
    
    //TODO: Schedule timer for duration
    activeTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [unowned self] timer in
      print(self.remaining.compoundTimeString())
      self.elapsed += 1
      if self.elapsed >= self.duration {
        self.timerState = .done
        timer.invalidate()
      }
    }
    
    //TODO: Schedule notification for completion
        
  }
  
  private func stop() {
    //TODO: Cancel active timer
    //TODO: Cancel active notification
        
  }
  
  func toggle() {
    print("Toggling!")
    switch timerState {
    case .pending:
      timerState = .inProgress
    case .inProgress:
      timerState = .pending
    case .done:
      print("Tried toggling \(name ?? "unnamed timer") but it was complete")
    }
  }
  
  func reset() {
    elapsed = 0
  }
  
  //MARK: - Private functions
  
  
  
}

//MARK: - Extensions

extension TimeInterval {
  private func hoursFromTotalSeconds() -> Int {
    return Int(Int(self) / 3600)
  }
  
  private func minutesFromTotalSeconds() -> Int {
    return Int((Int(self) - (hoursFromTotalSeconds() * 3600))/60)
  }
  
  private func secondsFromTotalSeconds() -> Int {
    return (Int(self) - (hoursFromTotalSeconds() * 3600) - (minutesFromTotalSeconds() * 60))
  }
  
  func compoundTime() -> CompoundTime {
    return (hoursFromTotalSeconds(), minutesFromTotalSeconds(), secondsFromTotalSeconds())
  }
  
  func compoundTimeString() -> String {
    return String(format: "%02d:%02d:%02d", compoundTime().hours, compoundTime().minutes, compoundTime().seconds)
  }
}
