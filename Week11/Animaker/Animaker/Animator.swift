//
//  Animator.swift
//  Animaker
//
//  Created by Bill Matthews on 2020-08-09.
//  Copyright © 2020 Bill Matthews. All rights reserved.
//

import UIKit

class Animator {
  
  private var choreography: UIViewPropertyAnimator?
  let object: UIView
  
  init(view: UIView) {
    self.object = view
  }
  
  var hasChoreography: Bool {
    get {
      choreography != nil
    }
  }
  
  func addColorChange() {
    if !hasChoreography {
      initChoreography()
    }
    
    choreography!.addAnimations {
      self.object.backgroundColor = UIColor.random
    }
    print("Adding Color step")
  }
  
  func addTranslation() {
    if !hasChoreography {
      initChoreography()
    }

    choreography!.addAnimations {
      let container = self.object.superview!
      let scaleOffset = self.object.frame.size.width / 2
      let xRangeMax = container.frame.size.width
      let yRangeMax = container.frame.size.height
      let randomX = CGFloat.random(in: scaleOffset...xRangeMax - scaleOffset)
      let randomY = CGFloat.random(in: scaleOffset...yRangeMax - scaleOffset)
      self.object.center = CGPoint(x: randomX, y: randomY)
    }
    print("Adding Translation step")
  }
  
  func addScaling() {
    if !hasChoreography {
      initChoreography()
    }
    
    choreography!.addAnimations {
      let randomScale = CGFloat.random(in: 0.1...2)
      self.object.transform = CGAffineTransform(scaleX: randomScale, y: randomScale)
    }
    print("Adding Scale step")
  }
  
  func runScript() {
    choreography?.startAnimation()
  }
  
  private func initChoreography() {
    choreography = UIViewPropertyAnimator(duration: TimeInterval.random(in: 0.1...1.0), curve: .easeInOut)
    choreography?.addCompletion({ (_) in
      self.choreography = nil
    })
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
