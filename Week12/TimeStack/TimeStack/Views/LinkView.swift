//
//  LinkView.swift
//  TimeStack
//
//  Created by Bill Matthews on 2020-08-15.
//  Copyright © 2020 Bill Matthews. All rights reserved.
//

import SwiftUI

struct LinkView: View {
  
  @Environment(\.presentationMode) var presentationMode
  
  @ObservedObject var list: TimerStackList
  @ObservedObject var selectedTicker: Ticker
  
  @State var selected = 1
  @State var linkSelection: Int = 0
  
  var availableConnections: [[Ticker]] {
    [list.availableHeads, list.availableTails]
  }
  
    var body: some View {
      VStack {
        Picker(selection: $selected, label: Text("Position")) {
          Text("Before").tag(0)
          Text("After").tag(1)
          Text("Unlink").tag(2)
        }
        .pickerStyle(SegmentedPickerStyle())
        
        if selected < 2 {
          Picker(selection: $linkSelection, label: Text("Connect to")) {
            ForEach(availableConnections[self.selected].indices) { index in
              Text(self.availableConnections[self.selected][index].name ?? "Unnamed (\(self.availableConnections[self.selected][index].remaining))").tag(index)
            }
          }.id(selected)
        }
        
        Button(action: {
          var position: Ticker.StackState!
          var target: Ticker?
          
          switch self.selected {
          case 0, 1:
            target = self.availableConnections[self.selected][self.linkSelection]
            position = self.selected == 0 ? .first : .last
          case 2:
            position = .solo
          default:
            break
          }
          
          self.list.moveTicker(self.selectedTicker, to: (target, position))
          self.presentationMode.wrappedValue.dismiss()
        }) {
          Text(selected == 2 ? "Unlink timers": "Link timers")
        }
      }
    }
}

struct LinkView_Previews: PreviewProvider {
    static var previews: some View {
      LinkView(list: TimerStackList(), selectedTicker: .demoTicker)
    }
}
