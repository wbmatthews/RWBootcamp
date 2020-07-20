//
//  Sauciness+CoreDataClass.swift
//  SandwichSaturation
//
//  Created by Bill Matthews on 2020-07-20.
//  Copyright © 2020 Jeff Rames. All rights reserved.
//
//

import Foundation
import CoreData


public class Sauciness: NSManagedObject {
  var sauceAmount: SauceAmount {
    get {
      guard let sauceAmountString = sauceFactor, let amount = SauceAmount(rawValue: sauceAmountString) else { return .none }
      return amount
    }
    set {
      sauceFactor = newValue.rawValue
    }
  }
}
