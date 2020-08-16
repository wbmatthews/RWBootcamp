//
//  HeaderView.swift
//  TimeStack
//
//  Created by Bill Matthews on 2020-08-16.
//  Copyright © 2020 Bill Matthews. All rights reserved.
//

import SwiftUI

struct HeaderView: View {
  
  @EnvironmentObject var list: TimerStackList
  @Binding var selectedTicker: Ticker?
  @Binding var showTickerEditor: Bool
  
  var body: some View {
    
    HStack {
      Text("TimerStacks")
        .font(.largeTitle)
        .bold()
      
      Spacer()
      
      Button(action: {
        withAnimation{
          self.list.isEditing.toggle()
        }
      }, label: {
        Image(systemName: "ellipsis.circle.fill")
          .resizable()
          .frame(width: 28, height: 28)
      })
        .disabled(list.isEmpty)
      
      Button(action: {
        unowned let newTicker = self.list.addTicker()
        self.selectedTicker = newTicker
        withAnimation{
          self.showTickerEditor = true
        }
      }, label: {
        Image(systemName: "plus.circle.fill")
          .resizable()
          .frame(width: 28, height: 28)
      })
        .disabled(self.list.isEditing)
      
    }
    .padding([.top, .horizontal])
  }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
      HeaderView(selectedTicker: .constant(Ticker.demoTicker), showTickerEditor: .constant(false)).environmentObject(TimerStackList())
    }
}
