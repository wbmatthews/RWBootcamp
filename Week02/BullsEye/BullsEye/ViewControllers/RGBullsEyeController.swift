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

import UIKit

class RGBullsEyeController: UIViewController {
  @IBOutlet weak var targetLabel: UILabel!
  @IBOutlet weak var targetTextLabel: UILabel!
  @IBOutlet weak var guessLabel: UILabel!
  
  @IBOutlet weak var redLabel: UILabel!
  @IBOutlet weak var greenLabel: UILabel!
  @IBOutlet weak var blueLabel: UILabel!
  
  @IBOutlet weak var redSlider: UISlider!
  @IBOutlet weak var greenSlider: UISlider!
  @IBOutlet weak var blueSlider: UISlider!
  
  @IBOutlet weak var roundLabel: UILabel!
  @IBOutlet weak var scoreLabel: UILabel!
  
  let game = BullsEyeGame<RGB>()
  
  @IBAction func aSliderMoved(sender: UISlider) {
    let r = Int(redSlider.value)
    let g = Int(greenSlider.value)
    let b = Int(blueSlider.value)

    game.round.currentValue = RGB(r: r, g: g, b: b)
    updateView()
  }
  
  @IBAction func showAlert(sender: AnyObject) {
    
    targetTextLabel.text = "r: \(game.round.targetValue.r) g: \(game.round.targetValue.g) b: \(game.round.targetValue.b)"
    
    let result = game.roundResults()
        
    let alert = UIAlertController(title: result.title, message: result.message, preferredStyle: .alert)
    
    let action = UIAlertAction(title: "OK", style: .default, handler: {
      action in
      self.game.newRound()
      self.resetView()
      self.updateView()
    })
    
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
    
  }
  
  @IBAction func startOver(sender: AnyObject) {
    game.restart()
    resetView()
    self.updateView()
  }
  
  func resetView() {
    targetTextLabel.text = "match this color"
    redSlider.value = 128
    greenSlider.value = 128
    blueSlider.value = 128
  }
  
  func updateView() {
    targetLabel.backgroundColor = UIColor(rgbStruct: game.round.targetValue)
    guessLabel.backgroundColor = UIColor(rgbStruct: game.round.currentValue)
    
    redLabel.text = String(Int(redSlider.value))
    greenLabel.text = String(Int(greenSlider.value))
    blueLabel.text = String(Int(blueSlider.value))
    
    roundLabel.text = String(game.roundNumber)
    scoreLabel.text = String(game.scoreTotal)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    game.restart()
    updateView()
  }
}

