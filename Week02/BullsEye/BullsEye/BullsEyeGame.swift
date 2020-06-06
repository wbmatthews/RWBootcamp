//
//  BullsEyeGame.swift
//  BullsEye
//
//  Created by Bill Matthews on 2020-06-05.
//  Copyright © 2020 Ray Wenderlich. All rights reserved.
//

import Foundation

struct BullsEyeGame {
  
  struct RoundResult {
    
    enum ResultType {
      case bullseye, within1percent, within5percent, within10percent, miss
    }
    
    let points: Int
    let resultType: ResultType
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
    let resultType: RoundResult.ResultType
    
    let difference = abs(scaledCurrent - targetValue)
    let percentageDiff = 100 * difference / scale
    var points = 100 - percentageDiff
    
    if difference == 0 {
      resultType = .bullseye
      points += 100
    } else if difference <= Int(scale / 100) {
      points += 50
      resultType = .within1percent
    }
    else if difference <= Int(scale / 20) {
      resultType = .within5percent
    } else if difference <= Int(scale / 10) {
      resultType = .within10percent
    } else {
      resultType = .miss
    }
    
    score += points
    return RoundResult(points: points, resultType: resultType)
  }
 
}
