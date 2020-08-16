//
//  TimerStackList.swift
//  TimeStack
//
//  Created by Bill Matthews on 2020-08-11.
//  Copyright © 2020 Bill Matthews. All rights reserved.
//

import Foundation
import Combine

class TimerStackList: ObservableObject {
  
  //MARK: - Stack declaration
  class Stack: ObservableObject, Identifiable {
    
    let id: UUID
    @Published var tickers: [Ticker]
    
    var alarms: [TickerAlarm] = []
    
    //MARK: - Computed variables
    
    private var isInProgress: Bool {
      if let _ = activeTicker {
        return true
      } else {
        return false
      }
    }
    
    fileprivate var activeTicker: Ticker? {
      tickers.first { $0.tickerState == .inProgress }
    }
    
    private var nextTicker: Ticker? {
      tickers.first { $0.tickerState == .pending }
    }
    
    private var remainingPendingTickers: [Ticker] {
      guard let nextTicker = nextTicker, let index = tickers.firstIndex(of: nextTicker) else { return [] }
      return Array<Ticker>(tickers[index...(tickers.count - 1)])
    }
    
    //MARK: - Initializers
    
    init(id: UUID = UUID(), tickers: [Ticker]) {
      self.id = id
      self.tickers = tickers
      report("Initialized")
    }
    
    deinit {
      report("Deinitialized")
    }
    
    func removeTicker(at index: Int) {
      report("Removing ticker from index \(index)")
      tickers[index].cancel()
      tickers.remove(at: index)
      updateAlarms()
    }
    
    func startNextTicker(elapsed: TimeInterval) {
      if let ticker = nextTicker {
        ticker.elapsed = elapsed
        ticker.tickerState = (ticker.remaining > 0) ? .inProgress : .done
        updateAlarms()
      }
    }
    
    func toggle() {
      updateAlarms()
    }
    
    private func updateAlarms() {
      
      var totalInterval = TimeInterval(0)
      
      alarms.forEach { $0.cancel() }
      alarms.removeAll()
      
      guard let activeTicker = activeTicker, let index = tickers.firstIndex(of: activeTicker) else { return }
      
      let remainingActiveTickers = Array<Ticker>(tickers[index...(tickers.count - 1)])
      for ticker in remainingActiveTickers {
        totalInterval += ticker.remaining
        let alarm = TickerAlarm(id: ticker.id, title: "\(ticker.name ?? "Your timer") has completed!", targetTime: totalInterval)
        alarm.schedule()
        alarms.append(alarm)
      }
    }
    
    private func report(_ string: String){
      print("🥞 Stack \(id.uuidString): \(string)")
    }
  }
  
  //MARK:- TimerStackList declaration begins
  
  static let demoStack: [Stack] = [
    Stack(tickers: [Ticker(name: "Demo1.0", duration: 10)]),
    Stack(tickers: [Ticker(name: "Demo2.0", duration: 86400)]),
    Stack(tickers: [Ticker(name: "Demo3.0", duration: 30, tickerState: .paused, stackState: .first), Ticker(name: "Demo3.1", duration: 40, tickerState: .pending, stackState: .last)])
  ]

  typealias StackPostion = (ticker: Ticker?, position: Ticker.StackState)
  
  @Published var stacks: [Stack]
  @Published var isEditing: Bool = false
  @Published var isEmpty: Bool = false
  
  //MARK: - Computed variables
  
  var allTickers: [Ticker] {
    stacks.flatMap { $0.tickers }
  }
  
  var availableHeads: [Ticker] {
    allTickers.filter { $0.stackState == .solo || $0.stackState == .first }
  }
  
  var availableTails: [Ticker] {
    allTickers.filter { $0.stackState == .solo || $0.stackState == .last }
  }
  
  //MARK: - Initializers
  
  init(stacks: [Stack] = [Stack(tickers: [Ticker(name: "Your first timer!", duration: 10)])]) {
    self.stacks = stacks
    registerObservers()
  }
  
  //MARK: - Public functions
  
  func addTicker(name: String? = nil, duration: CompoundTime, isRunning: Bool) {
    stacks.append(Stack(tickers: [Ticker(name: name, compoundTime: duration, isRunning: isRunning)]))
  }
  
  func addTicker() -> Ticker {
    let newTicker = Ticker(duration: 10)
    stacks.append(Stack(tickers: [newTicker]))
    isEmpty = false
    return newTicker
  }
  
  func moveTicker(_ ticker: Ticker, to target: StackPostion) {
    guard let currentIndex = getIndexOf(ticker: ticker),
      let targetIndex = getIndexOf(ticker: target.ticker ?? ticker) else { return }
    
    stacks[currentIndex.stack].tickers.remove(at: currentIndex.ticker)
    switch target.position {
    case .solo:
      ticker.tickerState = .paused
      stacks.append(Stack(tickers: [ticker]))
    case .first:
      ticker.tickerState = .paused
      stacks[targetIndex.stack].tickers.insert(ticker, at: 0)
    case .last:
      ticker.tickerState = .pending
      stacks[targetIndex.stack].tickers.append(ticker)
    case .stacked(let index):
      ticker.tickerState = .pending
      stacks[targetIndex.stack].tickers.insert(ticker, at: index)
    }
  }
  
  func removeTicker(_ ticker: Ticker?) {
    guard let ticker = ticker, let (stackIndex, tickerIndex) = getIndexOf(ticker: ticker) else { return }
    stacks[stackIndex].removeTicker(at: tickerIndex)
    
    if stacks[stackIndex].tickers.count == 0 {
      let removed = stacks.remove(at: stackIndex)
      report("Removed: \(removed)")
    }
    if stacks.count == 0 {
      stacks = []
      isEmpty = true
    }
  }
  
  //MARK: - Private functions
  
  private func getIndexOf(ticker: Ticker) -> (stack: Int, ticker: Int)? {
    guard
      let stackIndex = (stacks.firstIndex { $0.tickers.contains { $0 == ticker } }),
      let tickerIndex = (stacks[stackIndex].tickers.firstIndex { $0 == ticker })
      else { return nil }
    
    return (stackIndex, tickerIndex)
  }
  
  private func getIndexOf(tickerID id: UUID) -> (stack: Int, ticker: Int)? {
    guard let ticker = (allTickers.first { $0.id == id })  else { return nil }
    return getIndexOf(ticker: ticker)
  }
  
  private func report(_ string: String){
    print("📋 List: \(string)")
  }
  
}

//MARK: - Extensions for List and Stack

extension Notification.Name {
  static let timerDidFinish = Notification.Name.init("timerDidFinish")
  static let timerWasToggled = Notification.Name.init("timerWasToggled")
}

extension TimerStackList {
  func registerObservers() {
    NotificationCenter.default.addObserver(self, selector: #selector(timerDidFinish), name: .timerDidFinish, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(timerWasToggled), name: .timerWasToggled, object: nil)
  }
  
  @objc private func timerDidFinish(notification: Notification) {
    guard let id = (notification.userInfo?["id"] as? UUID), let index = getIndexOf(tickerID: id) else { return }
    stacks[index.stack].startNextTicker(elapsed: stacks[index.stack].tickers[index.ticker].elapsedPastDuration)
    report("Ticker \(index.ticker) of stack \(index.stack) finished")
    
  }
  
  @objc private func timerWasToggled(notification: Notification) {
    guard let id = (notification.userInfo?["id"] as? UUID), let index = getIndexOf(tickerID: id) else { return }
    stacks[index.stack].toggle()
    report("Ticker \(index.ticker) of stack \(index.stack) was toggled")
    
  }
}
