//
//  ViewController.swift
//  jQuiz
//
//  Created by Jay Strawn on 7/17/20.
//  Copyright © 2020 Jay Strawn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var soundButton: UIButton!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var clueLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scoreLabel: UILabel!
  
  private let imageURL = URL(string: "https://cdn1.edgedatg.com/aws/v2/abc/ABCUpdates/blog/2900129/8484c3386d4378d7c826e3f3690b481b/1600x900-Q90_8484c3386d4378d7c826e3f3690b481b.jpg")
  

    var clues: [Clue] = []
    var correctAnswerClue: Clue?
    var points: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        self.scoreLabel.text = "\(self.points)"

        if SoundManager.shared.isSoundEnabled == false {
            soundButton.setImage(UIImage(systemName: "speaker.slash"), for: .normal)
        } else {
            soundButton.setImage(UIImage(systemName: "speaker"), for: .normal)
        }

        SoundManager.shared.playSound()
      
      logoImageView.load(url: imageURL!)
      fetchClues()
        
    }

    @IBAction func didPressVolumeButton(_ sender: Any) {
        SoundManager.shared.toggleSoundPreference()
        if SoundManager.shared.isSoundEnabled == false {
            soundButton.setImage(UIImage(systemName: "speaker.slash"), for: .normal)
        } else {
            soundButton.setImage(UIImage(systemName: "speaker"), for: .normal)
        }
    }
  
  
  func fetchClues() {
    Networking.sharedInstance.getRandomCategory { (categoryID) in
      Networking.sharedInstance.selectCluesFromCategory(id: categoryID) { (clues, title) in
        self.clues = clues
        self.setUpView(with: title)
      }
    }
  }
  
  func setUpView(with title: String) {
    correctAnswerClue = clues.randomElement()
    print("selected correct clue: \(correctAnswerClue!.id)")
    DispatchQueue.main.async {
      self.categoryLabel.text = title.capitalized
      self.clueLabel.text = self.correctAnswerClue?.question
      self.scoreLabel.text = String(self.points)
      self.tableView.reloadData()
    }
  }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clues.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

      let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerOptionCell")!
      let answerLabel = cell.viewWithTag(1000) as! UILabel
      answerLabel.text = "What is \(clues[indexPath.row].answer!)?"
      
      return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      if clues[indexPath.row].answer == correctAnswerClue?.answer {
        points += correctAnswerClue!.value ?? 500
      }
      fetchClues()
    }
}


extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
