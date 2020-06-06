//
//  BullsEyeGame.swift
//  BullsEye
//
//  Created by Bill Matthews on 2020-06-05.
//  Copyright © 2020 Ray Wenderlich. All rights reserved.
//

import Foundation

protocol BullsEyeGameDelegate {
  
}

struct BullsEyeGame {
  
  struct RoundResult {
    let title: String
    let message: String
  }
  
  let rangeMin: Int
  let rangeMax: Int
  
  var currentValue: Float = 0
  var targetValue: Int = 0
  private (set) var score: Int = 0
  private (set) var round: Int = 0
  
  var scale: Int {
    rangeMax - rangeMin + 1
  }
  
  var scaledMax: Int {
    rangeMax - rangeMin
  }
  
  var targetValueInRange: Int {
    targetValue + rangeMin
  }
  
  var scaledCurrent: Int {
    Int(currentValue * Float(scaledMax))
  }
  
  init(rangeMin: Int, rangeMax: Int) {
    self.rangeMin = rangeMin
    self.rangeMax = rangeMax
  }
  
  mutating func start() {
    score = 0
    round = 0
    newRound()
  }
  
  mutating func newRound() {
    round += 1
    targetValue = Int.random(in: 0...scaledMax)
    currentValue = 0.5
  }
  
  mutating func scoreRound() -> RoundResult {
    let titleString: String
    let messageString: String
    
    let difference = abs(scaledCurrent - targetValue)
    let percentageDiff = 100 * difference / scale
    var points = 100 - percentageDiff

    if difference == 0 {
      titleString = "Perfect!"
      points += 100
    } else if difference <= Int(scale / 20) {
      titleString = "You almost had it!"
      if difference <= Int(scale / 100) {
        points += 50
      }
    } else if difference <= Int(scale / 10) {
      titleString = "Pretty good!"
    } else {
      titleString = "Not even close..."
    }
    
    score += points
    messageString = "You scored \(points) points."
    return RoundResult(title: titleString, message: messageString)
  }
  
}
