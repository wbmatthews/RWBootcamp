//
//  TickerRow.swift
//  TimeStack
//
//  Created by Bill Matthews on 2020-08-11.
//  Copyright © 2020 Bill Matthews. All rights reserved.
//

import SwiftUI

struct TickerRow: View {
  
  @ObservedObject var ticker: Ticker
  
  var body: some View {
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
    .padding()
    .frame(maxWidth: .infinity, alignment: .topLeading)
    .background(Color.secondary.opacity(0.5))
  }
  
}

struct TickerRow_Previews: PreviewProvider {
    static var previews: some View {
      TickerRow(ticker: Ticker.demoTicker)
    }
}
