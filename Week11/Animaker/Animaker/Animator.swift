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
      let xRange = container.frame.size.width / 2 - 100
      let yRange = container.frame.size.height / 2 - 200
    let randomX = self.object.center.x + CGFloat.random(in: -xRange...xRange)
    let randomY = self.object.center.y + CGFloat.random(in: -yRange...yRange)
    self.object.center = CGPoint(x: randomX, y: randomY)
    }
    print("Adding Translation step")
  }
  
  func addScaling() {
    if !hasChoreography {
      initChoreography()
    }
    
    choreography!.addAnimations {
      let randomX = CGFloat.random(in: -1...1)
      let randomY = CGFloat.random(in: -1...1)
      self.object.transform = CGAffineTransform(scaleX: randomX, y: randomY)
    }
    print("Adding Scale step")
  }
  
  func runScript() {
    choreography?.startAnimation()
  }
  
  private func initChoreography() {
    choreography = UIViewPropertyAnimator(duration: TimeInterval.random(in: 0.25...2.0), curve: .easeInOut)
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
