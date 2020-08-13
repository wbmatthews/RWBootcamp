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
    Stack(tickers: [Ticker(name: "Demo3.0", duration: 30), Ticker(name: "Demo3.1", duration: 40)])
  ]
  
  @Published var stacks: [Stack]
  
  init(stacks: [Stack] = []) {
    if stacks.isEmpty {
      self.stacks = TimerStackList.demoStack
    } else {
      self.stacks = stacks
    }
  }
  
  func addTicker(name: String? = nil, duration: CompoundTime, isRunning: Bool) {
    stacks.append(Stack(tickers: [Ticker(name: name, compoundTime: duration, isRunning: isRunning)]))
  }
  
  private func getIndexOf(ticker: Ticker) -> (Int, Int) {
    
    let stackIndex = stacks.firstIndex { $0.tickers.contains { $0.id == ticker.id } }!
    let tickerIndex = stacks[stackIndex].tickers.firstIndex { $0.id == ticker.id }!
    
    return (stackIndex, tickerIndex)
  }
  
  func removeTicker(_ ticker: Ticker?) {
    guard let ticker = ticker else { return }
    let (stackIndex, tickerIndex) = getIndexOf(ticker: ticker)
    stacks[stackIndex].removeTicker(at: tickerIndex)
    if stacks[stackIndex].tickers.count == 0 {
      stacks.remove(at: stackIndex)
    }
  }
}
