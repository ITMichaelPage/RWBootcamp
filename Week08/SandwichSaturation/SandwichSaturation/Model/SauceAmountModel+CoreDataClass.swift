//
//  SauceAmountModel+CoreDataClass.swift
//  SandwichSaturation
//
//  Created by Michael Page on 18/7/20.
//  Copyright © 2020 Jeff Rames. All rights reserved.
//
//

import Foundation
import CoreData


public class SauceAmountModel: NSManagedObject {
  
  var sauceAmount: SauceAmount {
    get {
      guard let sauceAmountString = self.sauceAmountString, let amount = SauceAmount(rawValue: sauceAmountString) else {
        return .none
      }
      return amount
    }
    set {
      self.sauceAmountString = newValue.rawValue
    }
  }
  
}
