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
  @IBOutlet weak var confirmationImageView: UIImageView!
  
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
    
    confirmationImageView.image = UIImage(systemName: "checkmark.circle.fill")
    confirmationImageView.translatesAutoresizingMaskIntoConstraints = false
    
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
  
  private func showConfirmation(from origin: CGPoint) {
    let newConfirmation = UIImageView(frame: confirmationImageView.frame)
    newConfirmation.image = confirmationImageView.image
    newConfirmation.center = origin
    newConfirmation.isHidden = false
    view.insertSubview(newConfirmation, aboveSubview: animationObject.superview!)
      
    UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
      newConfirmation.center.y -= 80
      newConfirmation.transform = .init(scaleX: 3.0, y: 3.0)
      newConfirmation.alpha = 0.75
    }, completion: { _ in
      newConfirmation.removeFromSuperview()
    })
  }
  
  

  @IBAction func playPressed(_ sender: UIButton) {
    toggleControls()
    if animator.hasChoreography {
      animator.dance()
      print("Starting animation")
      let buttons = view.subviews.filter { $0 is UIButton } as! [UIButton]
      buttons.forEach { $0.isEnabled = true }
    }
  }
  
  @IBAction func controlPressed(_ sender: UIButton) {
    sender.isEnabled = false
    switch sender.currentTitle {
    case "Color":
      animator.addColorChange()
      showConfirmation(from: sender.center)
    case "Translate":
      animator.addTranslation()
      showConfirmation(from: sender.center)
    case "Scale":
      animator.addScaling()
      showConfirmation(from: sender.center)
    default:
      print("Invalid Button")
    }
  }
}
