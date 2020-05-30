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
  @IBOutlet weak var slider1: UISlider!
  @IBOutlet weak var slider2: UISlider!
  @IBOutlet weak var slider3: UISlider!
  
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
      self.mainView.backgroundColor = UIColor(red: self.colourValues[0], green: self.colourValues[1], blue: self.colourValues[2], alpha: 1.0)
    }
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    
    setColourAlert.addAction(setColourAction)
    setColourAlert.addAction(cancelAction)
    
    present(setColourAlert, animated: true)

  }
  @IBAction func resetPressed() {
    colourNameLabel.text = "No colour set"
    mainView.backgroundColor = .systemBackground
    
    slider1.value = 0
    slider2.value = 0
    slider3.value = 0
    
  }
  
  @IBAction func sliderMoved(_ sender: UISlider) {
    switch sender.tag {
    case 100:
      colourValues[0] = CGFloat(sender.value)
      print(colourValues[0])
      case 200:
        colourValues[1] = CGFloat(sender.value)
      case 300:
        colourValues[2] = CGFloat(sender.value)
    default:
      return
    }
  }
}

