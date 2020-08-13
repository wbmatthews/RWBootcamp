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
    
    func removeTickers(at offsets: IndexSet) {
      tickers.remove(atOffsets: offsets)
    }
  }
  
  static let demoList = TimerStackList()
  static let demoStack: [Stack] = [
    Stack(tickers: [Ticker(name: "Demo1.0", duration: 10)]),
    Stack(tickers: [Ticker(name: "Demo2.0", duration: 86400)]),
    Stack(tickers: [Ticker(name: "Demo3.0", duration: 30), Ticker(name: "Demo3.1", duration: 40)])
  ]
  
  @Published var stacks: [Stack] = []
  
  func addTicker(name: String? = nil, duration: CompoundTime, isRunning: Bool) {
    stacks.append(Stack(tickers: [Ticker(name: name, compoundTime: duration, isRunning: isRunning)]))
  }
  
  func remove(stack: Stack) {
    let index = stacks.firstIndex { $0.id == stack.id }
    if let index = index {
      stacks[index].tickers.forEach { $0.cancel() }
      stacks[index].tickers.removeAll()
      stacks.remove(at: index)
    }
  }
  
}
