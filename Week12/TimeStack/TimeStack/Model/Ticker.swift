//
//  TimerStack.swift
//  Ticker
//
//  Created by Bill Matthews on 2020-08-11.
//  Copyright © 2020 Bill Matthews. All rights reserved.
//

import Foundation
import Combine

typealias CompoundTime = (hours: Int, minutes: Int, seconds: Int)

class Ticker: ObservableObject, Identifiable, Cancellable {
  
  enum TickerState {
    case paused, pending, inProgress, done
  }
  
  enum StackState: Equatable {
    case solo, first, last
    case stacked(Int)
  }
  
  static let demoTicker = Ticker(duration: 10)
  
  let id: UUID
  private var activeTimer: AnyCancellable?
  
  var name: String?
  
  private var lastTick: Date?
  private var duration: TimeInterval
  private var elapsed: TimeInterval = 0 {
    didSet {
      if elapsed < duration {
        remaining = duration - elapsed
      } else {
        remaining = 0
      }
    }
  }
  
  @Published var remaining: TimeInterval
  var proportionRemaining: Double {
    if remaining > 0 {
      return Double(duration) / Double(remaining)
    } else {
      return 86400
    }
  }
  
  @Published var tickerState: TickerState {
    didSet {
      switch tickerState {
      case .paused:
        NotificationCenter.default.post(name: .timerWasPaused, object: nil, userInfo: ["id": id])
        report("Paused")
        stop()
      case .pending:
        report("Pending")
      case .inProgress:
        report("Started for \(remaining.compoundTimeString())")
        start()
      case .done:
        NotificationCenter.default.post(name: .timerDidFinish, object: nil, userInfo: ["id": id])
        report("Completed")
      }
    }
  }
  private(set) var stackState: StackState = .solo
  
  var isInProgress: Bool {
    tickerState == .inProgress
  }
  
  //MARK: - Initializers
  
  init(id: UUID = UUID(), name: String? = nil, duration: TimeInterval, tickerState: TickerState = .paused, stackState: StackState = .solo) {
    self.id = id
    self.name = name
    self.duration = duration
    self.remaining = duration
    self.tickerState = tickerState
    self.stackState = stackState
    if self.tickerState == .inProgress {
      self.start()
    }
    print("Initializing \(id.uuidString) (\(name ?? "Unnamed")) - \(duration.compoundTimeString())")
  }
  
  convenience init(name: String?, compoundTime: CompoundTime, isRunning: Bool) {
    var tickerState: TickerState = .paused
    let duration = TimeInterval((3600 * compoundTime.hours) + (compoundTime.minutes * 60) + compoundTime.seconds)
    if isRunning { tickerState = .inProgress }
    self.init(name: name, duration: duration, tickerState: tickerState)
  }
  
  deinit {
    print("Deinitializing \(id.uuidString) (\(name ?? "Unnamed"))")
  }
  
  //MARK: - Public functions
  
  func toggle() {
    switch tickerState {
    case .pending:
      report("Tried toggling a stacked timer in pending state")
    case .paused:
      tickerState = .inProgress
    case .inProgress:
      tickerState = .paused
    case .done:
      reset()
    }
  }
  
  func reset() {
    elapsed = 0
    tickerState = .paused
  }
  
  func cancel() {
    tickerState = .paused
  }
  
  func update(newName: String? = nil, newDuration: CompoundTime? = nil) {
    if let newName = newName {
      self.name = newName.isEmpty ? nil : newName
    }
    if let newDuration = newDuration {
      self.duration = TimeInterval((3600 * newDuration.hours) + (newDuration.minutes * 60) + newDuration.seconds)
      self.elapsed = 0
    }
  }
  
  //MARK: - Private functions
  
  private func start() {
    //TODO: Consider completion handlers
    
    //TODO: Schedule timer for duration
    
//    completionTimer = Timer.publish
    
    activeTimer = Timer.publish(every: 1.0, tolerance: 0.5, on: .current, in: .common)
      .autoconnect()
      .sink{ [unowned self] _ in
        
        var elapsedTick = TimeInterval(1)
        
        if let lastTick = self.lastTick {
          let tickLength = Date().timeIntervalSince(lastTick).rounded()
          if tickLength > 1 { elapsedTick = tickLength }
        }
        self.elapsed += elapsedTick
        if self.elapsed >= self.duration {
          self.tickerState = .done
          self.activeTimer?.cancel()
        }
        self.lastTick = Date()
      }
    
    //TODO: Schedule notification for completion
        
  }
  
  private func stop() {
    //TODO: Cancel active notification
    activeTimer?.cancel()
    lastTick = nil
  }
  
  private func report(_ string: String){
    print("⏲ Timer \(id.uuidString): \(string)")
  }
  
  
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
