//
//  Sandwich+CoreDataProperties.swift
//  SandwichSaturation
//
//  Created by Michael Page on 18/7/20.
//  Copyright © 2020 Jeff Rames. All rights reserved.
//
//

import Foundation
import CoreData


extension Sandwich {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Sandwich> {
        return NSFetchRequest<Sandwich>(entityName: "Sandwich")
    }

    @NSManaged public var name: String
    @NSManaged public var imageName: String
    @NSManaged public var sauceAmount: SauceAmountModel

}
