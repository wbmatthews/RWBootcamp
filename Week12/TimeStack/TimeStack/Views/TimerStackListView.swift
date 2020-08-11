//
//  TimerStackListView.swift
//  TimerStack
//
//  Created by Bill Matthews on 2020-08-11.
//  Copyright © 2020 Bill Matthews. All rights reserved.
//

import SwiftUI

struct TimerStackListView: View {
  
  @ObservedObject var list: TimerStackList
  
  var body: some View {
    List {
      ForEach(list.stacks) { stack in
        ForEach(stack.tickers) { ticker in
          TickerRow(ticker: ticker)
        }
        .onDelete { (indexSet) in
          if stack.tickers.count > 1 {
            stack.removeTickers(at: indexSet)
          } else {
            self.list.remove(stack: stack)
          }
        }
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
      TimerStackListView(list: TimerStackList.demoList)
    }
}
