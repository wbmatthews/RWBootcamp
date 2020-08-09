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
  private let buttonSpacingOpen: CGFloat = 20
  private let buttonSpacingClosed: CGFloat = -60

  private var isDeployed = true
  private var isLaunched = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
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
  }
  
  @IBAction func controlPressed(_ sender: UIButton) {
  }
}

