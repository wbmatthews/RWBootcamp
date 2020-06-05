//
//  ViewController.swift
//  BullsEye
//
//  Created by Ray Wenderlich on 6/13/18.
//  Copyright © 2018 Ray Wenderlich. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  var game = BullsEyeGame(rangeMin: 1, rangeMax: 100)
  
  @IBOutlet weak var slider: UISlider!
  @IBOutlet weak var targetLabel: UILabel!
  @IBOutlet weak var scoreLabel: UILabel!
  @IBOutlet weak var roundLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()

    startNewGame()
  }
  
  @IBAction func showAlert() {
    
    let roundResult = game.scoreRound()
    
    let message = "You scored \(roundResult.points) points"
    
    let alert = UIAlertController(title: roundResult.string, message: message, preferredStyle: .alert)
    
    let action = UIAlertAction(title: "OK", style: .default, handler: {
      action in
      self.game.newRound()
      self.updateView(target: self.game.targetValueInRange, score: self.game.score, round: self.game.round, sliderValue: self.game.currentValue)
    })
    
    alert.addAction(action)
    
    present(alert, animated: true, completion: nil)
    
  }
  
  @IBAction func sliderMoved(_ slider: UISlider) {
    game.currentValue = slider.value
  }
  
  func updateView(target: Int, score: Int, round: Int, sliderValue: Float) {
    targetLabel.text = String(target)
    scoreLabel.text = String(score)
    roundLabel.text = String(round)
    slider.value = sliderValue
  }
  
  @IBAction func startNewGame() {
    game.start()
    updateView(target: game.targetValueInRange, score: game.score, round: game.round, sliderValue: game.currentValue)
    
  }
  
}



