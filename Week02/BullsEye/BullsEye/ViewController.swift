//
//  ViewController.swift
//  BullsEye
//
//  Created by Ray Wenderlich on 6/13/18.
//  Copyright © 2018 Ray Wenderlich. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
  @IBOutlet weak var slider: UISlider!
  @IBOutlet weak var targetLabel: UILabel!
  @IBOutlet weak var scoreLabel: UILabel!
  @IBOutlet weak var roundLabel: UILabel!
  
  var game = BullsEyeGame<Int>()
  
  var quickDiff: Int {
    return abs(game.round.targetValue - game.round.currentValue)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    startNewGame()
    slider.minimumTrackTintColor = UIColor.blue.withAlphaComponent(CGFloat(quickDiff)/100.0)
  }
  
  @IBAction func showAlert() {
    
    let result = game.roundResults()
        
    let alert = UIAlertController(title: result.title, message: result.message, preferredStyle: .alert)
    
    let action = UIAlertAction(title: "OK", style: .default, handler: {
      action in
      self.game.newRound()
      self.slider.value = 50
      self.updateView()
    })
    
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
    
  }
  
  @IBAction func aSliderMoved(_ slider: UISlider) {
    slider.minimumTrackTintColor = UIColor.blue.withAlphaComponent(CGFloat(quickDiff)/100.0)
    game.round.currentValue = Int(slider.value)
  }
  
  func updateView() {
    targetLabel.text = String(game.round.targetValue)
    scoreLabel.text = String(game.scoreTotal)
    roundLabel.text = String(game.roundNumber)
    slider.minimumTrackTintColor = UIColor.blue.withAlphaComponent(CGFloat(quickDiff)/100.0)
  }
  
  @IBAction func startNewGame() {
    game.restart()
    updateView()
  }
  
}



