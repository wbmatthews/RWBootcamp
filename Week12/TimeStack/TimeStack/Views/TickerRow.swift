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
    ZStack(alignment: .center) {
      
      BackgroundProgressView(proportion: ticker.proportionRemaining)
      
      VStack(alignment: .center) {
        HStack {
          Text(ticker.name ?? "Timer")
          Spacer()
          Button(action: {
            self.ticker.toggle()
          }) {
            Text(ticker.isInProgress ? "Stop" : "Start")
          }
        }
        .font(.system(size: 10, weight: Font.Weight.light, design: Font.Design.rounded))
        Text(ticker.remaining.compoundTimeString())
          .font(.system(size: 20, weight: Font.Weight.medium, design: Font.Design.monospaced))

      }
    .padding(8)
      .layoutPriority(1)
    }
  }
  
}

struct TickerRow_Previews: PreviewProvider {
    static var previews: some View {
      TickerRow(ticker: Ticker.demoTicker)
    }
}
