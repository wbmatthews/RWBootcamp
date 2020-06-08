//
//  BullsEyeGame.swift
//  BullsEye
//
//  Created by Bill Matthews on 2020-06-05.
//  Copyright © 2020 Ray Wenderlich. All rights reserved.
//

import Foundation

protocol BullsEyeableType {
  func difference(target:Self) -> Double
  static func newRandom() -> Self
  static var initialValue:Self { get }
}

class BullsEyeGame<Element: BullsEyeableType> {
  
  var scoreTotal: Int = 0
  var roundNumber: Int = 0
  var round: BullsEyeRound<Element>!
  
  func restart() {
    scoreTotal = 0
    roundNumber = 0
    newRound()
  }
  
  func roundResults() -> BullsEyeRoundResult {
    
    let result = round.score()
    scoreTotal += result.points
    
    return result
  }
  
  func newRound() {
    roundNumber += 1
    round = BullsEyeRound()
  }
  
  struct BullsEyeRound<Element: BullsEyeableType> {
    
    typealias Element = BullsEyeableType
        
    var currentValue: Element
    private (set) var targetValue: Element
    
    init() {
      targetValue = Element.newRandom()
      currentValue = Element.initialValue
    }
    
    func score() -> BullsEyeRoundResult {
      let resultType: BullsEyeRoundResult.ResultType
      
      let difference = targetValue.difference(target: currentValue)
      
      let percentageDiff = Int(100 * difference)
      var points = 100 - percentageDiff
      
      switch percentageDiff {
      case 0:
        resultType = .bullseye
        points += 100
      case 1:
        points += 50
        resultType = .within1percent
      case 2...5:
        resultType = .within5percent
      case 6...10:
        resultType = .within10percent
      default:
        resultType = .miss
      }
      
      return BullsEyeRoundResult(points: points, resultType: resultType)
    }
  }

  struct BullsEyeRoundResult {
    
    enum ResultType {
      case bullseye, within1percent, within5percent, within10percent, miss
    }
    
    let points: Int
    let resultType: ResultType
    let title: String
    let message: String
    
    init(points: Int, resultType: ResultType) {
      self.resultType = resultType
      self.points = points
      self.message = "You scored \(points) points"
      
      switch resultType {
      case .bullseye:
        self.title = "Bullseye!"
      case .within1percent:
        self.title = "You almost had it!"
      case .within5percent:
        self.title = "So close!"
      case .within10percent:
        self.title = "Pretty good"
      case .miss:
        self.title = "Not even close"
      }
    }
    
  }
  
}
