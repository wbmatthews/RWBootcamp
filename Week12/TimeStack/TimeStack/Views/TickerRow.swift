//
//  TickerRow.swift
//  TimeStack
//
//  Created by Bill Matthews on 2020-08-11.
//  Copyright © 2020 Bill Matthews. All rights reserved.
//

import SwiftUI

struct TickerRow: View {
  
  @EnvironmentObject var list: TimerStackList
  @ObservedObject var ticker: Ticker
  
  var body: some View {
    HStack {
      if list.isEditing {
        DeleteButton(ticker: ticker, isEditing: $list.isEditing)
          .padding(.horizontal,8)
      }
      ZStack(alignment: .leading){
        ProgressView(proportion: ticker.proportionRemaining)
          .frame(width: 28)
          .zIndex(0)
        Text(ticker.remaining.compoundTimeString())
          .frame(maxWidth: .infinity)
          .font(.system(size: 20, weight: Font.Weight.medium, design: Font.Design.monospaced))
          .zIndex(2)
        HStack {
          Text(ticker.name ?? "Timer")
          Spacer()
          Button(action: {
            self.ticker.toggle()
          }) {
            Text(ticker.isInProgress ? "Stop" : "Start")
          }
          .disabled(ticker.tickerState == .pending)
        }
        .layoutPriority(1)
        .frame(height:20)
        .background(Color(UIColor.systemBackground))
        .font(.system(size: 12, weight: Font.Weight.light, design: Font.Design.rounded))
      .padding(12)
        .padding(.leading, 22)
      }
    }
  }
}

struct TickerRow_Previews: PreviewProvider {
  static var previews: some View {
    TickerRow(ticker: Ticker.demoTicker).environmentObject(TimerStackList())
  }
}
