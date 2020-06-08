//
//  ViewController.swift
//  RevBullsEye
//
//  Created by Bill Matthews on 2020-06-07.
//  Copyright © 2020 Bill Matthews. All rights reserved.
//

import UIKit

class RevBullsEyeController: UIViewController, UITextFieldDelegate {

  @IBOutlet weak var guessField: UITextField! {
    didSet {
      guessField.delegate = self
    }
  }
  
  @IBOutlet weak var slider: UISlider!
  @IBOutlet weak var scoreLabel: UILabel!
  @IBOutlet weak var roundLabel: UILabel!
  
  var game = BullsEyeGame<Int>()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    startNewGame()
  }
  
  func updateView() {
    slider.value = Float(game.round.targetValue)
    guessField.text = ""
    
    scoreLabel.text = String(game.scoreTotal)
    roundLabel.text = String(game.roundNumber)
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
    if string == "" { return true }
    let entry = textField.text ?? ""
    
    if entry.count < 1 && string == "0" { return false }
    
    if entry.count >= 2 {
      if entry == "10" && string == "0" {
        return true
      } else {
        return false
      }
    }
    return true
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    view.endEditing(true)
    super.touchesBegan(touches, with: event)
  }
  
  @IBAction func showAlert() {
    
    view.endEditing(true)
    
    guard let entry = guessField.text, let guess = Int(entry) else { return }
    game.round.currentValue = guess
    
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
  
  @IBAction func startNewGame() {
    game.restart()
    updateView()
  }

}

