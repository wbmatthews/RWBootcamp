//
//  ViewController.swift
//  BullsEye
//
//  Created by Ray Wenderlich on 6/13/18.
//  Copyright © 2018 Ray Wenderlich. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  var game = BullsEyeGame(rangeMin: 0, rangeMax: 255)
  
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
    
    let roundResult = game.scoreRound()
    let (title, message) = generateRoundResultFrom(roundResult)
    
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    let action = UIAlertAction(title: "OK", style: .default, handler: {
      action in
      self.game.newRound()
      self.updateView()
    })
    
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
    
  }
  
  @IBAction func sliderMoved(_ slider: UISlider) {
    game.currentValue = slider.value
    print("target: \(game.targetValue), current: \(game.currentValue), currentAdjusted: \(game.scaledCurrent)")
  }
  
  func updateView() {
    targetLabel.text = String(game.targetValueInRange)
    scoreLabel.text = String(game.score)
    roundLabel.text = String(game.round)
    slider.value = game.currentValue
  }
  
  func generateRoundResultFrom(_ result:BullsEyeGame.RoundResult) -> (String, String) {
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
    game.start()
    updateView()
    
  }
  
}



