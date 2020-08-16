//
//  DeleteButton.swift
//  TimeStack
//
//  Created by Bill Matthews on 2020-08-16.
//  Copyright © 2020 Bill Matthews. All rights reserved.
//

import SwiftUI

struct DeleteButton: View {
  
  @EnvironmentObject var list: TimerStackList
  let ticker: Ticker
  
  @Binding var isEditing: Bool
  
  var body: some View {
    Button(action: {
      withAnimation{
        self.list.removeTicker(self.ticker)
      }
      self.list.objectWillChange.send()
      if self.list.stacks.isEmpty {
        self.isEditing = false
      }
    }, label: {
      Image(systemName: "trash.circle.fill")
        .resizable()
        .frame(width: 28, height: 28)
        .foregroundColor(.red)
    })
  }
}

struct DeleteButton_Previews: PreviewProvider {
    static var previews: some View {
      DeleteButton(ticker: Ticker.demoTicker, isEditing: .constant(true))
    }
}
