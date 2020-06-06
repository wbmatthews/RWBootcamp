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
    let points: Int
    let string : String
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
    let difference = abs(scaledCurrent - targetValue)
    let percentageDiff = 100 * difference / scale
       var points = 100 - percentageDiff
       let resultString: String
       if difference == 0 {
         resultString = "Perfect!"
         points += 100
       } else if difference <= Int(scale / 20) {
         resultString = "You almost had it!"
         if difference <= Int(scale / 100) {
           points += 50
         }
       } else if difference <= Int(scale / 10) {
         resultString = "Pretty good!"
       } else {
         resultString = "Not even close..."
       }
    
    score += points
    return RoundResult(points: points, string: resultString)
  }
  
}
