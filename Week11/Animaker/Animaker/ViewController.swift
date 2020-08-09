//
//  ViewController.swift
//  Animaker
//
//  Created by Bill Matthews on 2020-08-09.
//  Copyright © 2020 Bill Matthews. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var leftOfPlayConstraint: NSLayoutConstraint!
  @IBOutlet weak var rightOfPlayConstraint: NSLayoutConstraint!
  @IBOutlet weak var abovePlayConstraint: NSLayoutConstraint!
  
  @IBOutlet weak var animationObject: UIView!
  
  private let buttonSpacingOpen: CGFloat = 20
  private let buttonSpacingClosed: CGFloat = -60

  private var isDeployed = true
  private var isLaunched = false
  
  var animationScript: UIViewPropertyAnimator?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    animationObject.center = animationObject.superview!.center
//    animationObject.center = CGPoint(x: animationObject.superview!.frame.size.width - (animationObject.frame.size.width/2), y: animationObject.superview!.frame.size.height - (animationObject.frame.size.height/2))
    animationObject.translatesAutoresizingMaskIntoConstraints = false
    toggleControls()
  }
  
  private func toggleControls() {
    isDeployed.toggle()
    
    leftOfPlayConstraint.constant = isDeployed ? buttonSpacingOpen : buttonSpacingClosed
    rightOfPlayConstraint.constant = isDeployed ? buttonSpacingOpen : buttonSpacingClosed
    abovePlayConstraint.constant = isDeployed ? buttonSpacingOpen : buttonSpacingClosed
    
    if isLaunched {
      UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: isDeployed ? 0.6 : 1, initialSpringVelocity: 20, options: [], animations: {
        self.view.layoutIfNeeded()
      })
    } else {
      self.view.layoutIfNeeded()
      isLaunched = true
    }
  }

  @IBAction func playPressed(_ sender: UIButton) {
    if animationScript == nil {
      toggleControls()
      return
    }
    
    toggleControls()
    animationScript!.startAnimation()
    print("Starting animation")
    
    
    
  }
  
  @IBAction func controlPressed(_ sender: UIButton) {
    if animationScript == nil {
      animationScript = UIViewPropertyAnimator(duration: TimeInterval.random(in: 1...3), curve: .easeInOut)
      
      animationScript!.addCompletion({ (_) in
        self.animationScript = nil
        print("Animation complete")
      })
    }
    
    switch sender.currentTitle {
    case "Color":
      animationScript!.addAnimations {
        self.animationObject.backgroundColor = UIColor.random
      }
      print("Adding Color step")
    case "Translate":
      animationScript!.addAnimations { [object = self.animationObject!] in
        let container = object.superview!
        let xRange = container.frame.size.width / 2 - 100
        let yRange = container.frame.size.height / 2 - 200
        let randomX = object.center.x + CGFloat.random(in: -xRange...xRange)
        let randomY = object.center.y + CGFloat.random(in: -yRange...yRange)
        self.animationObject.center = CGPoint(x: randomX, y: randomY)
      }
      print("Adding Translation step")
    case "Scale":
      print("Adding Scale step")
    default:
      print("Invalid Button")
    }
  }
}

extension CGFloat {
    static var random: CGFloat {
           return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}
extension UIColor {
    static var random: UIColor {
           return UIColor(red: .random, green: .random, blue: .random, alpha: 1.0)
    }
}
