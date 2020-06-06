//
//  ViewController.swift
//  BullsEye
//
//  Created by Ray Wenderlich on 6/13/18.
//  Copyright © 2018 Ray Wenderlich. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
//  var game = BullsEyeGame(rangeMin: 1, rangeMax: 100)
  let rangeMin = 1
  let rangeMax = 100
  
  var round: BullsEyeRound!
  var game = BullsEyeGame()
  
  @IBOutlet weak var slider: UISlider!
  @IBOutlet weak var targetLabel: UILabel!
  @IBOutlet weak var scoreLabel: UILabel!
  @IBOutlet weak var roundLabel: UILabel!
  @IBOutlet weak var cheatLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    startNewGame()
  }
  
  @IBAction func showAlert() {
    
    let roundResult = round.score()
    let (title, message) = generateRoundResultFrom(roundResult)
    
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    let action = UIAlertAction(title: "OK", style: .default, handler: {
      action in
      self.round = BullsEyeRound(rangeMin: self.rangeMin, rangeMax: self.rangeMax)
      self.game.endRoundwith(points: roundResult.points)
      self.updateView()
    })
    
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
    
  }
  
  @IBAction func sliderMoved(_ slider: UISlider) {
    round.currentValue = slider.value
    print("target: \(round.targetValue), current: \(round.currentValue), currentAdjusted: \(round.scaledCurrent)")
  }
  
  func updateView() {
    targetLabel.text = String(round.targetValueInRange)
    scoreLabel.text = String(game.scoreTotal)
    roundLabel.text = String(game.roundNumber)
    slider.value = round.currentValue
  }
  
  func generateRoundResultFrom(_ result:BullsEyeRound.RoundResult) -> (String, String) {
    let title: String
    let message = "You scored \(result.points) points"
    
    switch result.resultType {
    case .bullseye:
      title = "Bullseye!"
    case .within1percent:
      title = "You almost had it!"
    case .within5percent:
      title = "So close!"
    case .within10percent:
      title = "Pretty good"
    case .miss:
      title = "Not even close"
    }
    return (title, message)
  }
  
  @IBAction func startNewGame() {
    game.restart()
    round = BullsEyeRound(rangeMin: rangeMin, rangeMax: rangeMax)
    updateView()
  }
  
}



