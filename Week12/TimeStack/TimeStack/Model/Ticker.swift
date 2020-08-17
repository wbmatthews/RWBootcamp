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

class Ticker: ObservableObject, Identifiable, Codable, Cancellable {
  
  enum CodingKeys: CodingKey {
    case id, name, duration, elapsed, lastTick, tickerState, stackState
  }
  
  enum TickerState: String, Codable {
    case paused, pending, inProgress, done
  }
  
  enum StackState: String, Equatable, Codable {
    case solo, first, last, stacked
  }
  
  static let demoTicker = Ticker(duration: 10)
  
  let id: UUID
  var name: String?
  
  private var lastTick: Date?
  private var duration: TimeInterval
  var elapsed: TimeInterval = 0 {
    didSet {
      if elapsed < duration {
        remaining = duration - elapsed
      } else {
        remaining = 0
      }
    }
  }
  
  private var activeTimer: AnyCancellable?
    
  @Published var remaining: TimeInterval

  @Published var tickerState: TickerState {
    didSet {
      switch tickerState {
      case .paused:
        NotificationCenter.default.post(name: .timerWasToggled, object: nil, userInfo: ["id": id])
        report("Paused")
        stopTicking()
      case .pending:
        report("Pending")
      case .inProgress:
        NotificationCenter.default.post(name: .timerWasToggled, object: nil, userInfo: ["id": id])
        report("Started for \(remaining.compoundTimeString())")
        startTicking()
      case .done:
        NotificationCenter.default.post(name: .timerDidFinish, object: nil, userInfo: ["id": id])
        report("Completed")
      }
    }
  }
  
  var stackState: StackState = .solo
  
  var isInProgress: Bool {
    tickerState == .inProgress
  }
  
  var proportionRemaining: Double {
    if remaining > 0 {
      return Double(duration) / Double(remaining)
    } else {
      return 86400
    }
  }
  
  var elapsedPastDuration: TimeInterval {
    elapsed > duration ? elapsed - duration : 0
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
      self.startTicking()
    }
    report("Initialized (\(name ?? "Unnamed")) - \(duration.compoundTimeString())")
  }
  
  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    self.id = try container.decode(UUID.self, forKey: .id)
    self.name = try container.decode(String?.self, forKey: .name)
    self.duration = try container.decode(TimeInterval.self, forKey: .duration)
    self.elapsed = try container.decode(TimeInterval.self, forKey: .elapsed)
    self.lastTick = try container.decode(Date?.self, forKey: .lastTick)
    self.tickerState = try container.decode(TickerState.self, forKey: .tickerState)
    self.stackState = try container.decode(StackState.self, forKey: .stackState)
    
    self.remaining = TimeInterval(-999) // Will recalculate when inited
  }
  
  convenience init(name: String?, compoundTime: CompoundTime, isRunning: Bool) {
    var tickerState: TickerState = .paused
    let duration = TimeInterval((3600 * compoundTime.hours) + (compoundTime.minutes * 60) + compoundTime.seconds)
    if isRunning { tickerState = .inProgress }
    self.init(name: name, duration: duration, tickerState: tickerState)
  }
  
  deinit {
    report("Deinitialized: (\(name ?? "Unnamed"))")
  }
  
  //MARK: - Public functions
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)

    try container.encode(id, forKey: .id)
    try container.encode(name, forKey: .name)
    try container.encode(duration, forKey: .duration)
    try container.encode(elapsed, forKey: .elapsed)
    try container.encode(lastTick, forKey: .lastTick)
    try container.encode(tickerState, forKey: .tickerState)
    try container.encode(stackState, forKey: .stackState)
  }
  
  func toggle() {
    switch tickerState {
    case .pending:
      report("Tried toggling a stacked timer in pending state")
    case .paused:
      tickerState = .inProgress
    case .inProgress:
      tickerState = .paused
    case .done:
      report("Tried toggling a complete timer")
    }
  }
  
  func reset() -> TimeInterval {
    elapsed = 0
    tickerState = .paused
    return duration
  }
  
  func cancel() {
    tickerState = .paused
  }
  
  func update(newName: String? = nil, newDuration: CompoundTime? = nil) {
    if let newName = newName {
      self.name = newName.isEmpty ? nil : newName
      NotificationCenter.default.post(name: .timerWasUpdated, object: nil)
    }
    if let newDuration = newDuration {
      self.duration = TimeInterval((3600 * newDuration.hours) + (newDuration.minutes * 60) + newDuration.seconds)
      self.elapsed = 0
      NotificationCenter.default.post(name: .timerWasUpdated, object: nil)
    }
  }
  
  //MARK: - Private functions
  
  private func startTicking() {
    //TODO: Consider completion handlers
    
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
          self.activeTimer?.cancel()
          self.tickerState = .done
        }
        self.lastTick = Date()
        NotificationCenter.default.post(name: .timerWasUpdated, object: nil)
      }
            
  }
  
  private func stopTicking() {
    //TODO: Cancel active notification
    activeTimer?.cancel()
    lastTick = nil
  }
  
  private func report(_ string: String){
    print("⏲ Timer \(id.uuidString): \(string)")
  }
  
  
}

//MARK: - Extensions

extension Ticker: Equatable {
  static func == (lhs: Ticker, rhs: Ticker) -> Bool {
    lhs.id == rhs.id
  }
}

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
