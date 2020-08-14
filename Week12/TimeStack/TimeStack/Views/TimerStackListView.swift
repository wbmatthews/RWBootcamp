//
//  TimerStackListView.swift
//  TimerStack
//
//  Created by Bill Matthews on 2020-08-11.
//  Copyright © 2020 Bill Matthews. All rights reserved.
//

import SwiftUI

struct TimerStackListView: View {
  
  @ObservedObject var list: TimerStackList
  
  @State var showNewTickerSheet: Bool = false
  @State var showDeleteAlert: Bool = false
  @State var showTickerEditor: Bool  = false
  
  @State var selectedTicker: Ticker? = nil
    
  var body: some View {
    
    
    
    ZStack(alignment: .center) {
      
      if showTickerEditor {
        
        Blur(style: .systemUltraThinMaterialDark)
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
        
        HStack {
          Text("TimerStacks")
            .font(.largeTitle)
            .bold()
          
          Spacer()
          
          Button(action: {
//            self.showNewTickerSheet.toggle()
            
            self.selectedTicker = self.list.addTicker()
            withAnimation{
              self.showTickerEditor = true
            }
          }, label: {
            Image(systemName: "plus.circle.fill")
              .resizable()
              .frame(width: 28, height: 28)
          })
        }
        .padding([.top, .horizontal])
        
        
        Divider()

        ScrollView {

          VStack(alignment: .leading, spacing: 0) {
            
            ForEach(list.stacks) { stack in
              
              Section(header: Text("")) {
                
                ForEach(stack.tickers) { ticker in
                  TickerRow(ticker: ticker)
                    .onTapGesture {
                      print("Tapped \(ticker.name ?? "unnamed")")
                      self.selectedTicker = ticker
                      withAnimation {
                        self.showTickerEditor = true
                      }
                  }
                    .onLongPressGesture(minimumDuration: 1.0) {
                      print("Long pressed \(ticker.name ?? "unnamed")")
                      self.showDeleteAlert = true
                      self.selectedTicker = ticker
                  }
                  .alert(isPresented: self.$showDeleteAlert) {
                    Alert(
                      title: Text("Delete \(self.selectedTicker?.name ?? "timer")?"),
                      message: Text("This cannot be undone."),
                      primaryButton: Alert.Button.destructive(Text("Delete")) {
                        self.list.removeTicker(self.selectedTicker)
                        self.selectedTicker = nil
                      },
                      secondaryButton: Alert.Button.cancel()
                    )
                  }
                }
              }
            }
            Spacer()
          }
          .animation(.easeIn)
          .padding(.horizontal)
//          .sheet(isPresented: $showNewTickerSheet) {
//            NewTicker(list: self.list)
//          }
        }
      }
    .zIndex(0)
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    TimerStackListView(list: TimerStackList())
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
