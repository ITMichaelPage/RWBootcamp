//
//  RegisterTableViewCells.swift
//  jQuiz
//
//  Created by Michael Page on 24/7/20.
//  Copyright © 2020 Jay Strawn. All rights reserved.
//

import UIKit

func registerTableViewCells(tableView: UITableView, cellIdentifiers: [TableViewCellIdentifier]) {
    for cellIdentifier in cellIdentifiers {
        // Load the nib with that cellIdentifier.
        let cellNib = UINib(nibName: cellIdentifier.rawValue, bundle: nil)
        // Register cellNib to make dequeueReusableCell(withIdentifier) use the nib.
        tableView.register(cellNib, forCellReuseIdentifier: cellIdentifier.rawValue)
    }
}
