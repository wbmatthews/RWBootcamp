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
  let rangeMin = 0
  let rangeMax = 1000
  
  var game: BullsEyeGame!
    
  @IBOutlet weak var slider: UISlider!
  @IBOutlet weak var targetLabel: UILabel!
  @IBOutlet weak var scoreLabel: UILabel!
  @IBOutlet weak var roundLabel: UILabel!
  @IBOutlet weak var rangeMinLabel: UILabel!
  @IBOutlet weak var rangeMaxLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    game = BullsEyeGame(rangeMin: rangeMin, rangeMax: rangeMax)
    rangeMinLabel.text = String(rangeMin)
    rangeMaxLabel.text = String(rangeMax)
    startNewGame()
  }
  
  @IBAction func showAlert() {
    
    let roundResult = game.round.score()
    let (title, message) = generateRoundResultFrom(roundResult)
    
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    let action = UIAlertAction(title: "OK", style: .default, handler: {
      action in
      self.game.round = BullsEyeRound(rangeMin: self.rangeMin, rangeMax: self.rangeMax)
      self.game.endRoundwith(points: roundResult.points)
      self.updateView()
    })
    
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
    
  }
  
  @IBAction func sliderMoved(_ slider: UISlider) {
    game.round.currentValue = slider.value
    print("target: \(game.round.targetValue), current: \(game.round.currentValue), currentAdjusted: \(game.round.scaledCurrent)")
  }
  
  func updateView() {
    targetLabel.text = String(game.round.targetValueInRange)
    scoreLabel.text = String(game.scoreTotal)
    roundLabel.text = String(game.roundNumber)
    slider.value = game.round.currentValue
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
    updateView()
  }
  
}



