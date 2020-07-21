//
//  FileManager.swift
//  SandwichSaturation
//
//  Created by Michael Page on 15/7/20.
//  Copyright © 2020 Jeff Rames. All rights reserved.
//

import Foundation

extension FileManager {
  static var documentsDirectoryURL: URL {
    `default`.urls(for: .documentDirectory, in: .userDomainMask)[0]
  }
}
