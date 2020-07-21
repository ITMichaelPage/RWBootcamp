//
//  SauceAmountModel+CoreDataProperties.swift
//  SandwichSaturation
//
//  Created by Michael Page on 20/7/20.
//  Copyright © 2020 Jeff Rames. All rights reserved.
//
//

import Foundation
import CoreData


extension SauceAmountModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SauceAmountModel> {
        return NSFetchRequest<SauceAmountModel>(entityName: "SauceAmountModel")
    }

    @NSManaged public var sauceAmountString: String?
    @NSManaged public var sandwich: NSSet?

}

// MARK: Generated accessors for sandwich
extension SauceAmountModel {

    @objc(addSandwichObject:)
    @NSManaged public func addToSandwich(_ value: Sandwich)

    @objc(removeSandwichObject:)
    @NSManaged public func removeFromSandwich(_ value: Sandwich)

    @objc(addSandwich:)
    @NSManaged public func addToSandwich(_ values: NSSet)

    @objc(removeSandwich:)
    @NSManaged public func removeFromSandwich(_ values: NSSet)

}
