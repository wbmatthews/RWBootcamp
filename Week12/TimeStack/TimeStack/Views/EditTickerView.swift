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
    
    HStack(alignment: .center) {
      VStack {
        ProgressView(proportion: self.ticker!.proportionRemaining)
          .background(Color.white)
          .frame(width: 20)
      }
      VStack {
        HStack {
          TextField("Timer name (optional)", text: self.$name)
            .font(.system(size: 18, weight: Font.Weight.light, design: Font.Design.rounded))
            .foregroundColor(.primary)
            .padding(4)
            .padding(.leading, 12)
            .background(Color.secondary.opacity(0.5).blendMode(.darken))
            .cornerRadius(StandardViewValues.cornerRadius)
          
          Button(action: {
            let duration = self.ticker?.reset()
            self.entryDuration = duration!.compoundTime()
          }, label: {
            Image(systemName: "arrow.counterclockwise.circle.fill")
              .resizable()
              .frame(width: 28, height: 28)
              .foregroundColor(.orange)
          })
          
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
            .layoutPriority(1)
          
          VStack() {
            Text(String(format: "%02d",self.entryDuration.seconds))
              .font(.system(size: 46, weight: .medium, design: .monospaced))
            Text("s").bold()
            Stepper("hours", value: self.$entryDuration.seconds, in: 0...59)
          }
        }
        .labelsHidden()
      }

    }
    .frame(height:200)
    .background(Color(UIColor.systemBackground))
    .mask(RoundedRectangle(cornerRadius: StandardViewValues.cornerRadius))
    .shadow(color: Color.black.opacity(0.3), radius: 5, x: 5, y: 5)
    .shadow(color: Color.white.opacity(0.7), radius: 5, x: -2, y: -2)
      .onAppear {
        if self.ticker!.tickerState == .inProgress {
          self.ticker!.tickerState = .paused
        }
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
