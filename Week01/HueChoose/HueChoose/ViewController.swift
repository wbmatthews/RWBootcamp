//
//  ViewController.swift
//  HueChoose
//
//  Created by Bill Matthews on 2020-05-30.
//  Copyright © 2020 Bill Matthews. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  enum ColourMode {
    case rgb
    case hsb
    
    func componentNames() -> [String] {
      switch self {
      case .rgb:
        return ["Red","Green","Blue"]
      case .hsb:
        return ["Hue","Saturation","Brightness"]
      }
    }
    
    func maxValues() -> [Int] {
      switch self {
      case .rgb:
        return [255,255,255]
      case .hsb:
        return [360,100,100]
      }
    }
    
    func tintColours() -> [UIColor] {
      switch self {
      case .rgb:
        return [.systemRed,.systemGreen,.systemBlue]
      case .hsb:
        return [.systemGray,.systemGray2,.systemGray3]
      }
    }
    
    func value(_ value: CGFloat, at index: Int) -> Int {
      Int(CGFloat(self.maxValues()[index]) * value)
    }
  }

  @IBOutlet weak var colourNameLabel: UILabel!
  @IBOutlet var mainView: UIView!
  @IBOutlet weak var previewView: UIView!
  @IBOutlet weak var modeSwitch: UISegmentedControl!

  @IBOutlet var sliders: [UISlider]!
  @IBOutlet var sliderLabels: [UILabel]!
  @IBOutlet var sliderValueLabels: [UILabel]!
  
  var colourValues: [CGFloat] = [0,0,0]
  var colourMode: ColourMode = .rgb
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    previewView.layer.cornerRadius = 5
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let nextView = segue.destination as? InfoViewController {
      nextView.mode = colourMode
    }
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
    
    colourValues = [0,0,0]
    _ = sliderValueLabels.map { $0.text = "0" }
    _ = sliders.map { $0.value = 0 }
    previewView.backgroundColor = .black

  }
  
  @IBAction func sliderMoved(_ sender: UISlider) {
    let index = sender.tag
    colourValues[index] = CGFloat(sender.value)
    updateUI(for: index)
  }
  
  @IBAction func modeSwitched() {
    let currentColour = previewView.backgroundColor!
    var value0: CGFloat = 0
    var value1: CGFloat = 0
    var value2: CGFloat = 0
    
    if colourMode == .rgb {
      colourMode = .hsb
      currentColour.getHue(&value0, saturation: &value1, brightness: &value2, alpha: nil)
    } else {
      colourMode = .rgb
      currentColour.getRed(&value0, green: &value1, blue: &value2, alpha: nil)
    }
    
    colourValues[0] = value0
    colourValues[1] = value1
    colourValues[2] = value2
    
    for index in sliderLabels.indices {
      sliderLabels[index].text = colourMode.componentNames()[index]
    }
    
    uiModeSwitch()
  }
  
  func updateUI(for index: Int) {
      setSliderValueLabel(at: index)

    if colourMode == .rgb {
      previewView.backgroundColor = UIColor(red: colourValues[0], green: colourValues[1], blue: colourValues[2], alpha: 1.0)
    } else {
      previewView.backgroundColor = UIColor(hue: colourValues[0], saturation: colourValues[1], brightness: colourValues[2], alpha: 1.0)
    }
  }
  
  func uiModeSwitch() {
    for index in sliders.indices {
      sliders[index].value = Float(colourValues[index])
      setSliderValueLabel(at: index)
      sliders[index].thumbTintColor = colourMode.tintColours()[index]
      sliders[index].minimumTrackTintColor = colourMode.tintColours()[index]
    }
  }
  
  func setSliderValueLabel(at index: Int) {
      sliderValueLabels[index].text = ("\(colourMode.value(colourValues[index], at: index))")
  }
  
}

