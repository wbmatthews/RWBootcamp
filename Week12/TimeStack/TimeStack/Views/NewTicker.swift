//
//  NewTicker.swift
//  TimeStack
//
//  Created by Bill Matthews on 2020-08-11.
//  Copyright © 2020 Bill Matthews. All rights reserved.
//

import SwiftUI

struct NewTicker: View {
  
  @State var entryDuration = CompoundTime(0,0,10)
  @State var name = ""
  
  var body: some View {
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
      Button(action: {
        
      }, label: {
        Text("Save new timer")
          .multilineTextAlignment(.center)
        })
        .frame(maxWidth: .infinity)
    }
  }
}

struct NewTicker_Previews: PreviewProvider {
    static var previews: some View {
        NewTicker()
    }
}
