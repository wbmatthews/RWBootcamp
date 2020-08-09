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
  
  private var animator: Animator!
  
  private let buttonSpacingOpen: CGFloat = 20
  private let buttonSpacingClosed: CGFloat = -60

  private var isDeployed = true
  private var isLaunched = false
    
  override func viewDidLoad() {
    super.viewDidLoad()
    animator = Animator(view: animationObject)
    
    let size = animationObject.superview!.frame.size.width / 4
    animationObject.frame.size = CGSize(width: size, height: size)
    animationObject.center = animationObject.superview!.center
    animationObject.layer.cornerRadius = size / 8
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
    toggleControls()
    if animator.hasChoreography {
      animator.runScript()
      print("Starting animation")
      let buttons = view.subviews.filter { $0 is UIButton } as! [UIButton]
      buttons.forEach { $0.isEnabled = true }
    }
  }
  
  @IBAction func controlPressed(_ sender: UIButton) {
    
    switch sender.currentTitle {
    case "Color":
      animator.addColorChange()
      sender.isEnabled = false
    case "Translate":
      animator.addTranslation()
      sender.isEnabled = false
    case "Scale":
      animator.addScaling()
      sender.isEnabled = false
    default:
      print("Invalid Button")
    }
  }
}
