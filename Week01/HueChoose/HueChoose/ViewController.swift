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
      self.mainView.backgroundColor = .blue
      // set colour here
    }
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    
    setColourAlert.addAction(setColourAction)
    setColourAlert.addAction(cancelAction)
    
    present(setColourAlert, animated: true)

  }
  @IBAction func resetPressed() {
    colourNameLabel.text = "No colour set"
    mainView.backgroundColor = .systemBackground
  }
  
}

