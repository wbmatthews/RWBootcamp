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
  
  class Stack: ObservableObject, Identifiable {
    let id: UUID
    @Published var tickers: [Ticker]
    
    init(id: UUID = UUID(), tickers: [Ticker]) {
      self.id = id
      self.tickers = tickers
    }
    
    func removeTicker(at index: Int) {
      print("Removing ticker from index \(index)")
      tickers[index].cancel()
      tickers.remove(at: index)
    }
  }
  
  static let demoStack: [Stack] = [
    Stack(tickers: [Ticker(name: "Demo1.0", duration: 10)]),
    Stack(tickers: [Ticker(name: "Demo2.0", duration: 86400)]),
    Stack(tickers: [Ticker(name: "Demo3.0", duration: 30, stackState: .first), Ticker(name: "Demo3.1", duration: 40, stackState: .last)])
  ]
  
  typealias StackPostion = (ticker: Ticker?, position: Ticker.StackState)
  @Published var stacks: [Stack]
  
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
  
  init(stacks: [Stack] = []) {
    if stacks.isEmpty {
      self.stacks = TimerStackList.demoStack
    } else {
      self.stacks = stacks
    }
  }
  
  //MARK: - Public functions
  
  func addTicker(name: String? = nil, duration: CompoundTime, isRunning: Bool) {
    stacks.append(Stack(tickers: [Ticker(name: name, compoundTime: duration, isRunning: isRunning)]))
  }
  
  func addTicker() -> Ticker {
    let newTicker = Ticker(duration: 10)
    stacks.append(Stack(tickers: [newTicker]))
    return newTicker
  }
  
  func moveTicker(_ ticker: Ticker, to target: StackPostion) {
    let currentIndex = getIndexOf(ticker: ticker)
    let targetIndex = getIndexOf(ticker: target.ticker ?? ticker)
    stacks[currentIndex.stack].tickers.remove(at: currentIndex.ticker)
    switch target.position {
    case .solo:
      stacks.append(Stack(tickers: [ticker]))
    case .first:
      stacks[targetIndex.stack].tickers.insert(ticker, at: 0)
    case .last:
      stacks[targetIndex.stack].tickers.append(ticker)
    case .stacked(let index):
      stacks[targetIndex.stack].tickers.insert(ticker, at: index)
    }
  }
  
  func removeTicker(_ ticker: Ticker?) {
    guard let ticker = ticker else { return }
    let (stackIndex, tickerIndex) = getIndexOf(ticker: ticker)
    stacks[stackIndex].removeTicker(at: tickerIndex)
    if stacks[stackIndex].tickers.count == 0 {
      stacks.remove(at: stackIndex)
    }
  }
  
  //MARK: - Private functions
  
  private func getIndexOf(ticker: Ticker) -> (stack: Int, ticker: Int) {
    
    let stackIndex = stacks.firstIndex { $0.tickers.contains { $0.id == ticker.id } }!
    let tickerIndex = stacks[stackIndex].tickers.firstIndex { $0.id == ticker.id }!
    
    return (stackIndex, tickerIndex)
  }
  
}
