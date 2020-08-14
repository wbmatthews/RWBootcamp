//
//  NewTicker.swift
//  TimeStack
//
//  Created by Bill Matthews on 2020-08-11.
//  Copyright © 2020 Bill Matthews. All rights reserved.
//

import SwiftUI

struct EditView: View {
  
  @Binding var ticker: Ticker?
  @Binding var isDisplayed: Bool
  
  @State var entryDuration = CompoundTime(0,0,0)
  @State var name = ""
  
  @State var nameWasEdited = false
  @State var durationWasEdited = false
  
  var body: some View {
    GeometryReader { geometry in
      
      ZStack {
        
        BackgroundProgressView(proportion: self.ticker!.proportionRemaining)
          .background(Color.white)
          .frame(height: geometry.size.width * 3/4, alignment: .center)
          .cornerRadius(15)
          .zIndex(2)
          .padding(.horizontal, 8)
        
        VStack {
          HStack {
            TextField("Timer name (optional)", text: self.$name)
              .font(.system(size: 18, weight: Font.Weight.light, design: Font.Design.rounded))
            
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
              }
            }, label: {
              Image(systemName: "xmark.circle.fill")
                .resizable()
                .frame(width: 28, height: 28)
            })
          }
          
          VStack {
            HStack {
              Text(String(format: "%02d",self.entryDuration.hours))
              Text(":")
              Text(String(format: "%02d",self.entryDuration.minutes))
              Text(":")
              Text(String(format: "%02d",self.entryDuration.seconds))
            }
            .font(.system(size: 46, weight: .light, design: .monospaced))
            .padding(.top, 5)
            HStack {
              VStack(alignment: .center) {
                Text("h").bold()
                Stepper("hours", value: self.$entryDuration.hours, in: 0...23)
              }
              VStack(alignment: .center) {
                Text("m").bold()
                Stepper("hours", value: self.$entryDuration.minutes, in: 0...59)
              }
              VStack(alignment: .center) {
                Text("s").bold()
                Stepper("hours", value: self.$entryDuration.seconds, in: 0...59)
              }
            }
            .labelsHidden()
            .padding(.horizontal)
          }
        }
        .padding(.horizontal,20)
        .zIndex(3)
      }
      .transition(.scale)
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
    EditView(ticker: .constant(TimerStackList.demoStack[0].tickers[0]), isDisplayed: .constant(true))
  }
}
