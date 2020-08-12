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
    Stack(tickers: [Ticker(duration: 10)]),
    Stack(tickers: [Ticker(name: "Potatoes", duration: 86400)]),
    Stack(tickers: [Ticker(duration: 30)])
  ]
  
  @Published var stacks: [Stack] = TimerStackList.demoStack
  
  func addTicker(name: String? = nil, duration: CompoundTime, isRunning: Bool) {
    let newTicker = Ticker(name: name, compoundTime: duration, isRunning: isRunning)
    stacks.append(Stack(tickers: [newTicker]))
  }
  
  func remove(stack: Stack) {
    let index = stacks.firstIndex { $0.id == stack.id }
    if let index = index {
      stacks.remove(at: index)
    }
  }
  
}
