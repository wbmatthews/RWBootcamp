//
//  Sauciness+CoreDataProperties.swift
//  SandwichSaturation
//
//  Created by Bill Matthews on 2020-07-20.
//  Copyright © 2020 Jeff Rames. All rights reserved.
//
//

import Foundation
import CoreData


extension Sauciness {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Sauciness> {
        return NSFetchRequest<Sauciness>(entityName: "Sauciness")
    }

    @NSManaged public var sauceFactor: String?
    @NSManaged public var sandwich: NSSet

}

// MARK: Generated accessors for sandwich
extension Sauciness {

    @objc(addSandwichObject:)
    @NSManaged public func addToSandwich(_ value: Sandwich)

    @objc(removeSandwichObject:)
    @NSManaged public func removeFromSandwich(_ value: Sandwich)

    @objc(addSandwich:)
    @NSManaged public func addToSandwich(_ values: NSSet)

    @objc(removeSandwich:)
    @NSManaged public func removeFromSandwich(_ values: NSSet)

}
