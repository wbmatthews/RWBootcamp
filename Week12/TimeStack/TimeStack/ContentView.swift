//
//  ContentView.swift
//  TimerStack
//
//  Created by Bill Matthews on 2020-08-11.
//  Copyright © 2020 Bill Matthews. All rights reserved.
//

import SwiftUI

struct ContentView: View {
  
//  @ObservedObject var list: TimerStackList
  @ObservedObject var ticker: Ticker
  
  var body: some View {
    VStack {
      HStack {
        Text(ticker.name ?? "Timer")
        Text(ticker.remaining.compoundTimeString())
          .font(.system(Font.TextStyle.body, design: Font.Design.monospaced))
        Button(action: {
          self.ticker.toggle()
        }) {
          Text(ticker.isInProgress ? "Stop" : "Start")
        }
      }
//      HStack {
//        Text(list.tickers[0].name ?? "Timer")
//        Text(list.tickers[0].remaining.compoundTimeString())
//          .font(.system(Font.TextStyle.body, design: Font.Design.monospaced))
//        Button(action: {
//          self.list.tickers[0].toggle()
//        }) {
//          Text(list.tickers[0].isInProgress ? "Stop" : "Start")
//        }
//      }
//      List {
//        ForEach(list.tickers, id:\.id) { ticker in
//              HStack {
//                Text(ticker.name ?? "Timer")
//                Text(ticker.remaining.compoundTimeString())
//                  .font(.system(Font.TextStyle.body, design: Font.Design.monospaced))
//                Button(action: {
//                  ticker.toggle()
//                }) {
//                  Text(ticker.isInProgress ? "Stop" : "Start")
//                }
//              }
//        }
//      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
      ContentView(ticker: Ticker.demoTicker)
    }
}
