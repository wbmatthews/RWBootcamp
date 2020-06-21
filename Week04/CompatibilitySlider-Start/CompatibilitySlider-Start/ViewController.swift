//
//  ViewController.swift
//  CompatibilitySlider-Start
//
//  Created by Jay Strawn on 6/16/20.
//  Copyright © 2020 Jay Strawn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var compatibilityItemLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var questionLabel: UILabel!

  var compatibilityItems = [
    "Cats",
    "Dogs",
    "Travel",
    "Spicy Food",
    "Sci-Fi",
    "Rom-Coms",
    "Sports",
    "Spirituality",
    "Physical Fitness",
    "Hot weather",
    "Snow",
    "Politics"
  ]
    var currentItemIndex = 0

    var person1 = Person(id: 1, items: [:])
    var person2 = Person(id: 2, items: [:])
    var currentPerson: Person?

    override func viewDidLoad() {
      super.viewDidLoad()
      currentPerson = person1
      updateUI()
    }

    @IBAction func sliderValueChanged(_ sender: UISlider) {
        print(sender.value)
    }
  
  @IBAction func didTapIcon(_ sender: UITapGestureRecognizer) {
    if let value = sender.view?.tag {
      slider.value = Float(value)
    }
  }
  
    @IBAction func didPressNextItemButton(_ sender: Any) {
      currentPerson?.items[compatibilityItems[currentItemIndex]] = slider.value
      currentItemIndex += 1
      if currentItemIndex < compatibilityItems.count {
        updateUI()
      } else {
        let alert: UIAlertController
        if currentPerson == person1 {
          
          alert = UIAlertController(title: "All done!", message: "Thanks for your answers. Please pass the device to your potential soul mate so they can answer.", preferredStyle: .alert)
          let action = UIAlertAction(title: "OK", style: .default) { alert in
            self.currentPerson = self.person2
            self.currentItemIndex = 0
            self.updateUI()
          }
          alert.addAction(action)
          
        } else {
          let compatibilityScore = calculateCompatibility()
          print(compatibilityScore)
          
          alert = UIAlertController(title: "Results", message: "You two are \(compatibilityScore) compatible.", preferredStyle: .alert)
          let action = UIAlertAction(title: "OK", style: .default) { alert in
                      
            self.person1 = Person(id: 1, items: [:])
            self.person2 = Person(id: 2, items: [:])
            self.currentPerson = self.person1
            self.currentItemIndex = 0
            self.updateUI()
            
          }
          alert.addAction(action)
        }
        
        present(alert, animated: true, completion: nil)
      }
    }
  
  func updateUI() {
    guard let currentPerson = currentPerson else { return }
    questionLabel.text = "User \(String(currentPerson.id)), what do you think about..."
    compatibilityItemLabel.text = compatibilityItems[currentItemIndex]
    slider.value = 3
  }

    func calculateCompatibility() -> String {
        // If diff 0.0 is 100% and 5.0 is 0%, calculate match percentage
        var percentagesForAllItems: [Double] = []

        for (key, person1Rating) in person1.items {
            let person2Rating = person2.items[key] ?? 0
            let difference = abs(person1Rating - person2Rating)/5.0
            percentagesForAllItems.append(Double(difference))
        }

        let sumOfAllPercentages = percentagesForAllItems.reduce(0, +)
        let matchPercentage = sumOfAllPercentages/Double(compatibilityItems.count)
        print(matchPercentage, "%")
        let matchString = 100 - (matchPercentage * 100).rounded()
        return "\(matchString)%"
    }

}

