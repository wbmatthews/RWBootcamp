///*
//* Copyright (c) 2015 Razeware LLC
//*
//* Permission is hereby granted, free of charge, to any person obtaining a copy
//* of this software and associated documentation files (the "Software"), to deal
//* in the Software without restriction, including without limitation the rights
//* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//* copies of the Software, and to permit persons to whom the Software is
//* furnished to do so, subject to the following conditions:
//*
//* The above copyright notice and this permission notice shall be included in
//* all copies or substantial portions of the Software.
//*
//* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//* THE SOFTWARE.
//*/
//
//import Foundation
//
//class BullsEyeGame {
//  
//  struct BullsEyeRound {
//    
//    struct RoundResult {
//      
//      enum ResultType {
//        case bullseye, within1percent, within5percent, within10percent, miss
//      }
//      
//      let points: Int
//      let resultType: ResultType
//      let title: String
//      let message: String
//      
//      init(points: Int, resultType: ResultType) {
//        self.resultType = resultType
//        self.points = points
//        self.message = "You scored \(points) points"
//        
//        switch resultType {
//        case .bullseye:
//          self.title = "Bullseye!"
//        case .within1percent:
//          self.title = "You almost had it!"
//        case .within5percent:
//          self.title = "So close!"
//        case .within10percent:
//          self.title = "Pretty good"
//        case .miss:
//          self.title = "Not even close"
//        }
//      }
//      
//    }
//    
//    var currentValue: RGB = RGB()
//    var targetValue: RGB = RGB()
//    
//    init() {
//      targetValue = RGB(r: Int.random(in: 0...255), g: Int.random(in: 0...255), b: Int.random(in: 0...255))
//    }
//    
//    func score() -> RoundResult {
//      let resultType: RoundResult.ResultType
//      
//      let difference = targetValue.difference(target: currentValue)
//      
//      let percentageDiff = Int(100 * difference)
//      var points = 100 - percentageDiff
//      
//      switch percentageDiff {
//      case 0:
//        resultType = .bullseye
//        points += 100
//      case 1:
//        points += 50
//        resultType = .within1percent
//      case 2...5:
//        resultType = .within5percent
//      case 6...10:
//        resultType = .within10percent
//      default:
//        resultType = .miss
//      }
//      
//      return RoundResult(points: points, resultType: resultType)
//    }
//   
//  }
//
//  var scoreTotal: Int = 0
//  var roundNumber: Int = 0
//  var round: BullsEyeRound!
//  
//  func restart() {
//    scoreTotal = 0
//    roundNumber = 0
//    newRound()
//  }
//  
//  func roundResults() -> BullsEyeRound.RoundResult {
//    
//    let result = round.score()
//    scoreTotal += result.points
//    
//    return result
//  }
//  
//  func newRound() {
//    roundNumber += 1
//    round = BullsEyeRound()
//  }
//}
