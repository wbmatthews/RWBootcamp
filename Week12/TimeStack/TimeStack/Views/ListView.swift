//
//  TimerStackListView.swift
//  TimerStack
//
//  Created by Bill Matthews on 2020-08-11.
//  Copyright © 2020 Bill Matthews. All rights reserved.
//

import SwiftUI

struct ListView: View {
  
  @EnvironmentObject var list: TimerStackList
    
  @State var showNewTickerSheet: Bool = false
  @State var showTickerEditor: Bool  = false
  
  @State var selectedTicker: Ticker? = nil
      
  var body: some View {
    
    ZStack(alignment: .center) {
      
      if showTickerEditor {
                
        Blur(style: .systemUltraThinMaterial)
          .animation(.easeIn(duration: 0.05))
          .transition(.opacity)
          .edgesIgnoringSafeArea(.all)
          .layoutPriority(1.0)
          .zIndex(1)
          .transition(.opacity)

        EditTickerView(ticker: $selectedTicker, isDisplayed: $showTickerEditor)
          .animation(.easeInOut(duration: 0.1))
          .transition(.scale)
          .zIndex(2)
      }
      
      VStack {
        HeaderView(selectedTicker: $selectedTicker, showTickerEditor: $showTickerEditor)
        Divider()

        ScrollView {
          VStack(alignment: .leading, spacing: 8) {
            ForEach(list.stacks) { stack in
              StackView(stack: stack, selectedTicker: self.$selectedTicker, showTickerEditor: self.$showTickerEditor)
            }
            Spacer()
          }
          .padding(.horizontal)
        }
      }
    .zIndex(0)
    }
  }
}

struct Blur: UIViewRepresentable {
  var style: UIBlurEffect.Style = .systemMaterial
  func makeUIView(context: Context) -> UIVisualEffectView {
    return UIVisualEffectView(effect: UIBlurEffect(style: style))
  }
  func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
    uiView.effect = UIBlurEffect(style: style)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ListView().environmentObject(TimerStackList())
  }
}

