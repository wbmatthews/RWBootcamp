//
//  Int+BullsEyeableValue.swift
//  RevBullsEye
//
//  Created by Bill Matthews on 2020-06-08.
//  Copyright © 2020 Bill Matthews. All rights reserved.
//

import Foundation

extension Int: BullsEyeableType {
  func difference(target: Int) -> Double {
    Double(abs(self - target)) / 100.0
  }
  
  static func newRandom() -> Int {
    Int.random(in: 1...100)
  }
  
  static var initialValue: Int {
    return 50
  }
  
  
}
