//
//  NewTicker.swift
//  TimeStack
//
//  Created by Bill Matthews on 2020-08-11.
//  Copyright © 2020 Bill Matthews. All rights reserved.
//

import SwiftUI

struct NewTicker: View {
  
  @Environment(\.presentationMode) var presentationMode
  
  @ObservedObject var list: TimerStackList
  
  @State var entryDuration = CompoundTime(0,0,10)
  @State var name = ""
  @State var runTimer: Bool = false
  
  var body: some View {
    NavigationView {
      Form {
        Section(header: Text("Timer name:")) {
          TextField("Optional", text: $name)
            .font(.system(size: 18, weight: Font.Weight.light, design: Font.Design.rounded))
        }
        
        Section(header: Text("Duration:")) {
          VStack {
            HStack {
              Text(String(format: "%02d",entryDuration.hours))
              Text(":")
              Text(String(format: "%02d",entryDuration.minutes))
              Text(":")
              Text(String(format: "%02d",entryDuration.seconds))
            }
            .font(.system(size: 46, weight: .light, design: .monospaced))
            .padding(.top, 5)
            HStack {
              VStack(alignment: .center) {
                Text("h").bold()
                Stepper("hours", value: $entryDuration.hours, in: 0...23)
              }
              VStack(alignment: .center) {
                Text("m").bold()
                Stepper("hours", value: $entryDuration.minutes, in: 0...59)
              }
              VStack(alignment: .center) {
                Text("s").bold()
                Stepper("hours", value: $entryDuration.seconds, in: 0...59)
              }
            }
            .labelsHidden()
            .padding(.horizontal)
          }
        }
        .padding(.bottom, 5)
        
        Section {
          Toggle(isOn: $runTimer, label: {
            Text("Start timer immediately")
          })
        }
        
        Button(action: {
          let tickerName = self.name.isEmpty ? nil : self.name
          self.list.addTicker(name: tickerName, duration: self.entryDuration, isRunning: self.runTimer)
          self.presentationMode.wrappedValue.dismiss()
        }, label: {
          Text("Save new timer")
        })
          .frame(maxWidth: .infinity)
      }
      .navigationBarTitle("Add New Timer", displayMode: .automatic)
    }
  }
}

struct NewTicker_Previews: PreviewProvider {
  static var previews: some View {
    NewTicker(list: TimerStackList())
  }
}
