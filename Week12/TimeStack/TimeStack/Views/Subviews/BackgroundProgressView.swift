//
//  BackgroundProgressView.swift
//  TimeStack
//
//  Created by Bill Matthews on 2020-08-13.
//  Copyright © 2020 Bill Matthews. All rights reserved.
//

import SwiftUI

struct BackgroundProgressView: View {
    
    var proportion: Double
    
    var body: some View {
      GeometryReader { geometry in
        HStack {
          VStack(spacing: 0) {
            Rectangle()
              .fill(Color(UIColor.secondarySystemFill))
            Rectangle()
              .fill(Color(UIColor.systemGreen))
              .frame(height: geometry.size.height/CGFloat(self.proportion))
          }
          .animation(.easeOut)
          
          Rectangle()
            .fill(Color(UIColor.systemBackground))
            .frame(width: geometry.size.width * 0.75)
        }
      }
    }
}

struct BackgroundProgressView_Previews: PreviewProvider {
    static var previews: some View {
      BackgroundProgressView(proportion: 2)
    }
}
