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
  private var targetValue: Float = 0
  private (set) var score: Int = 0
  private (set) var round: Int = 0
  
  var rangeSpread: Int {
    rangeMax - rangeMin + 1
  }
  
  var targetValueInRange: Int {
    Int(targetValue * Float(rangeSpread))
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
    targetValue = Float.random(in: 0...1)
    currentValue = 0.5
  }
  
  mutating func scoreRound() -> RoundResult {
    let difference = Int(abs(targetValue - currentValue) * Float(rangeSpread))
       var points = rangeSpread - difference
       
       let resultString: String
       if difference == 0 {
         resultString = "Perfect!"
         points += rangeSpread
       } else if difference < (rangeSpread / 20) {
         resultString = "You almost had it!"
         if difference == 1 {
           points += rangeSpread / 2
         }
       } else if difference < (rangeSpread / 10) {
         resultString = "Pretty good!"
       } else {
         resultString = "Not even close..."
       }
    
    score += points
    return RoundResult(points: points, string: resultString)
  }
  
}
