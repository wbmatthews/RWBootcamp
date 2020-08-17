//
//  StackView.swift
//  TimeStack
//
//  Created by Bill Matthews on 2020-08-16.
//  Copyright © 2020 Bill Matthews. All rights reserved.
//

import SwiftUI

struct StackView: View {
  
  @EnvironmentObject var list: TimerStackList
  @ObservedObject var stack: TimerStackList.Stack
  
  @Binding var selectedTicker: Ticker?
  @Binding var showTickerEditor: Bool
  
  @State var showLinkView: Bool = false
  
  
  var body: some View {
    VStack(spacing: 0) {
      ForEach(stack.tickers) { ticker in
        TickerRow(ticker: ticker)
          .onTapGesture {
            print("Tapped \(ticker.name ?? "unnamed")")
            self.selectedTicker = ticker
            withAnimation(.easeIn(duration:0.5)) {
              self.showTickerEditor = true
            }
        }
        .onLongPressGesture(minimumDuration: 1.0) {
          print("Long pressed \(ticker.name ?? "unnamed")")
          self.selectedTicker = ticker
          self.showLinkView = true
        }
        .sheet(isPresented: self.$showLinkView) { LinkView(selectedTicker: self.selectedTicker!).environmentObject(self.list) }
      }
    }
    .background(Color(UIColor.systemBackground))
    .mask(RoundedRectangle(cornerRadius: StandardViewValues.cornerRadius))
    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 3, y: 3)
    .shadow(color: Color.white.opacity(0.5), radius: 5, x: -1, y: -1)
    
  }
}

struct StackView_Previews: PreviewProvider {
  static var previews: some View {
    StackView(stack: TimerStackList.demoStack[2], selectedTicker: .constant(nil), showTickerEditor: .constant(false)).environmentObject(TimerStackList())
  }
}