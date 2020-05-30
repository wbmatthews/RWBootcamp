//
//  ViewController.swift
//  HueChoose
//
//  Created by Bill Matthews on 2020-05-30.
//  Copyright © 2020 Bill Matthews. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var colourNameLabel: UILabel!
  @IBOutlet var mainView: UIView!
  @IBOutlet weak var previewView: UIView!
  @IBOutlet var sliders: [UISlider]!
  @IBOutlet var sliderLabels: [UILabel]!

  var colourValues: [CGFloat] = [0,0,0]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }

  @IBAction func setColourPressed() {
    let setColourAlert = UIAlertController(title: "Name your colour", message: nil, preferredStyle: .alert)
    setColourAlert.addTextField { (colourNameField) in
      colourNameField.placeholder = "Enter colour name"
    }
    let setColourAction = UIAlertAction(title: "Set Colour", style: .default) { action in
      guard let textFields = setColourAlert.textFields, let colourNameField = textFields[0].text else { return }
      self.colourNameLabel.text = colourNameField
      self.mainView.backgroundColor = self.previewView.backgroundColor!
    }
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    
    setColourAlert.addAction(setColourAction)
    setColourAlert.addAction(cancelAction)
    
    present(setColourAlert, animated: true)

  }
  
  @IBAction func resetPressed() {
    colourNameLabel.text = "No colour set"
    mainView.backgroundColor = .systemBackground
    
    _ = colourValues.map { _ in 0 }
    _ = sliderLabels.map { $0.text = "0" }
    _ = sliders.map { $0.value = 0 }
    previewView.backgroundColor = .black

  }
  
  @IBAction func sliderMoved(_ sender: UISlider) {
    let index = sender.tag
    colourValues[index] = CGFloat(sender.value)
    updateUI(for: index)
  }
  
  func updateUI(for index: Int) {
    sliderLabels[index].text = ("\(Int(255 * colourValues[index]))")
    previewView.backgroundColor = UIColor(red: colourValues[0], green: colourValues[1], blue: colourValues[2], alpha: 1.0)
  }
}

