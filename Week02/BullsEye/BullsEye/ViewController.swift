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
  @IBOutlet weak var cheatLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    startNewGame()
  }
  
  @IBAction func showAlert() {
    
    let roundResult = game.scoreRound()
    
    let alert = UIAlertController(title: roundResult.title, message: roundResult.message, preferredStyle: .alert)
    
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
  
  @IBAction func startNewGame() {
    game.start()
    updateView()
    
  }
  
}



