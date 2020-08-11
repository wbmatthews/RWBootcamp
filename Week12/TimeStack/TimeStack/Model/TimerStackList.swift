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
  }
  
  static let demoList = TimerStackList()
  static let demoStack: [Stack] = [
    Stack(tickers: [Ticker(duration: 10)]),
    Stack(tickers: [Ticker(name: "Potatoes", duration: 60)]),
    Stack(tickers: [Ticker(duration: 30)])
  ]
  static let demoTickerList: [Ticker] = [
    Ticker(duration: 10),
    Ticker(name: "Potatoes", duration: 60),
    Ticker(duration: 30)
  ]
  
  @Published var stacks: [Stack] = TimerStackList.demoStack
  @Published var tickers: [Ticker] = TimerStackList.demoTickerList
}
