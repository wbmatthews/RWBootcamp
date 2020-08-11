//
//  ContentView.swift
//  TimerStack
//
//  Created by Bill Matthews on 2020-08-11.
//  Copyright © 2020 Bill Matthews. All rights reserved.
//

import SwiftUI

struct ContentView: View {
  
  @ObservedObject var timerStack: TimerStack
  
    var body: some View {
      VStack {
        HStack {
          Text(timerStack.name ?? "Timer")
          Text(timerStack.remaining.compoundTimeString())
        }
        Button(action: {
          self.timerStack.toggle()
        }) {
          Text(timerStack.isInProgress ? "Stop" : "Start")
        }
      }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
      ContentView(timerStack: TimerStack.previewList[0])
    }
}
