/*
* Copyright (c) 2015 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import Foundation

class BullsEyeGame {
  var scoreTotal: Int = 0
  var roundNumber: Int = 0
  
  func restart() {
    scoreTotal = 0
    roundNumber = 1
  }
  
  func endRoundwith(points: Int) {
    roundNumber += 1
    scoreTotal += points
  }
}

struct RGBullsEyeRound {
  
  struct RoundResult {
    
    enum ResultType {
      case bullseye, within1percent, within5percent, within10percent, miss
    }
    
    let points: Int
    let resultType: ResultType
  }
  
  let rangeMin: Int
  let rangeMax: Int
  
  var currentValue: Float = 0.5
  var targetValue: Int = 0
  
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
    targetValue = Int.random(in: 0...scaledMax)
  }
  
  func score() -> RoundResult {
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
    } else if difference <= Int(scale / 20) {
      resultType = .within5percent
    } else if difference <= Int(scale / 10) {
      resultType = .within10percent
    } else {
      resultType = .miss
    }
    
    return RoundResult(points: points, resultType: resultType)
  }
 
}

