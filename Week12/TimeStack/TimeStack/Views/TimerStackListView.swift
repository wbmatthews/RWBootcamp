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
  
  @State var showNewTickerSheet: Bool = false
  @State var showDeleteAlert: Bool = false
  
  @State var selectedTicker: Ticker? = nil
    
  var body: some View {
    
    
    
    VStack {
      
      HStack {
        Text("TimerStacks")
          .font(.largeTitle)
          .bold()
        
        Spacer()
        
        Button(action: {
          self.showNewTickerSheet.toggle()
        }, label: {
          Image(systemName: "plus.circle.fill")
            .resizable()
            .frame(width: 40, height: 40)
        })
      }
      .padding([.top, .horizontal])
      
      Divider()

      ScrollView {

        VStack(alignment: .leading, spacing: 0) {
          
          ForEach(list.stacks) { stack in
            
            Section(header: Text("")) {
              
              ForEach(stack.tickers) { ticker in
                TickerRow(ticker: ticker)
                  .onLongPressGesture(minimumDuration: 1.0) {
                    print("Long pressing \(ticker.name ?? "unnamed")")
                    self.showDeleteAlert = true
                    self.selectedTicker = ticker
                }
                .alert(isPresented: self.$showDeleteAlert) {
                  Alert(
                    title: Text("Delete \(self.selectedTicker?.name ?? "timer")?"),
                    message: Text("This cannot be undone."),
                    primaryButton: Alert.Button.destructive(Text("Delete")) {
                      self.list.removeTicker(self.selectedTicker)
                      self.selectedTicker = nil
                    },
                    secondaryButton: Alert.Button.cancel()
                  )
                }
              }
            }
          }
          Spacer()
        }
        .animation(.easeIn)
        .padding(.horizontal)
        .sheet(isPresented: $showNewTickerSheet) {
          NewTicker(list: self.list)
        }
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    TimerStackListView(list: TimerStackList())
  }
}
