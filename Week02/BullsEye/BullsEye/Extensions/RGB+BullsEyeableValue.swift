//
//  RGB+BullsEyeableValue.swift
//  BullsEye
//
//  Created by Bill Matthews on 2020-06-08.
//  Copyright © 2020 Ray Wenderlich. All rights reserved.
//

import Foundation

extension RGB: BullsEyeableType {
  static func newRandom() -> RGB {
    RGB(r: Int.random(in: 0...255), g: Int.random(in: 0...255), b: Int.random(in: 0...255))
  }
  
  static var initialValue: RGB {
    RGB()
  }
}
