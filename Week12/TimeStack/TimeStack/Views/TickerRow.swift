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
      }
      
      ZStack(alignment: .center) {
        
        BackgroundProgressView(proportion: ticker.proportionRemaining)
          .cornerRadius(12)
        
        ZStack(alignment: .center) {
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
          .font(.system(size: 12, weight: Font.Weight.light, design: Font.Design.rounded))
          Text(ticker.remaining.compoundTimeString())
            .font(.system(size: 20, weight: Font.Weight.medium, design: Font.Design.monospaced))
          
        }
        .padding(8)
        .layoutPriority(1)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.secondary))
      }
      .padding(.horizontal)
    }
  }
  
}

struct TickerRow_Previews: PreviewProvider {
  static var previews: some View {
    TickerRow(ticker: Ticker.demoTicker).environmentObject(TimerStackList())
  }
}
