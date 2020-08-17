//
//  ProgressView.swift
//  TimeStack
//
//  Created by Bill Matthews on 2020-08-13.
//  Copyright © 2020 Bill Matthews. All rights reserved.
//

import SwiftUI

struct ProgressView: View {
    
    var proportion: Double
    
  var body: some View {
    GeometryReader { geometry in
      VStack(spacing: 0) {
        Rectangle()
          .fill(Color(UIColor.secondarySystemFill))
         Rectangle()
          .fill(Color(UIColor.systemGreen))
          .frame(height: geometry.size.height/CGFloat(self.proportion))
      }
      .animation(.easeIn)
    }
  }
}

struct BackgroundProgressView_Previews: PreviewProvider {
    static var previews: some View {
      ProgressView(proportion: 2)
    }
}
