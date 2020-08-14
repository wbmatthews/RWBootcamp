//
//  NewTicker.swift
//  TimeStack
//
//  Created by Bill Matthews on 2020-08-11.
//  Copyright © 2020 Bill Matthews. All rights reserved.
//

import SwiftUI

struct EditTickerView: View {
  
  @Binding var ticker: Ticker?
  @Binding var isDisplayed: Bool
  
  @State var entryDuration = CompoundTime(0,0,0)
  @State var name = ""
  
  @State var nameWasEdited = false
  @State var durationWasEdited = false
  
  var body: some View {
    ZStack(alignment: .center) {
      
      BackgroundProgressView(proportion: self.ticker!.proportionRemaining)
        .background(Color.white)
        .cornerRadius(15)
        .zIndex(2)
      
      VStack(alignment: .center) {
        HStack {
          TextField("Timer name (optional)", text: self.$name)
            .font(.system(size: 18, weight: Font.Weight.light, design: Font.Design.rounded))
            .foregroundColor(.primary)
            .padding(4)
            .padding(.leading, 12)
            .background(Color.secondary.opacity(0.5).blendMode(.darken))
            .cornerRadius(12)
          
          Button(action: {
            withAnimation{
              self.isDisplayed.toggle()
            }
            if self.name != (self.ticker?.name ?? "") {
              self.nameWasEdited = true
            }
            
            if self.entryDuration != (self.ticker?.remaining.compoundTime())! {
              self.durationWasEdited = true
            }
            if self.nameWasEdited || self.durationWasEdited {
              self.ticker!.update(newName: self.nameWasEdited ? self.name : nil, newDuration: self.durationWasEdited ? self.entryDuration : nil)
              self.ticker!.objectWillChange.send()
            }
          }, label: {
            Image(systemName: "xmark.circle.fill")
              .resizable()
              .frame(width: 28, height: 28)
          })
        }
        .padding(.horizontal, 8)
        
        HStack(alignment: .firstTextBaseline, spacing: 0) {
          VStack {
            Text(String(format: "%02d",self.entryDuration.hours))
              .font(.system(size: 46, weight: .medium, design: .monospaced))
            Text("h").bold()
            Stepper("hours", value: self.$entryDuration.hours, in: 0...23)
          }
          Text(":").font(.system(size: 46, weight: .medium, design: .rounded))
          VStack {
            Text(String(format: "%02d",self.entryDuration.minutes))
              .font(.system(size: 46, weight: .medium, design: .monospaced))
            Text("m").bold()
            Stepper("hours", value: self.$entryDuration.minutes, in: 0...59)
          }
          Text(":").font(.system(size: 46, weight: .medium, design: .rounded))
          
          VStack() {
            Text(String(format: "%02d",self.entryDuration.seconds))
              .font(.system(size: 46, weight: .medium, design: .monospaced))
            Text("s").bold()
            Stepper("hours", value: self.$entryDuration.seconds, in: 0...59)
          }
        }
        .labelsHidden()
      }
      .zIndex(3)
      .layoutPriority(1)
      .padding(.vertical)
    }
    .onAppear {
      self.ticker!.pause()
      self.name = self.ticker!.name ?? ""
      self.entryDuration = self.ticker!.remaining.compoundTime()
    }
  }
}

struct EditView_Previews: PreviewProvider {
  static var previews: some View {
    EditTickerView(ticker: .constant(TimerStackList.demoStack[0].tickers[0]), isDisplayed: .constant(true))
  }
}
