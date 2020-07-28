//
//  AnswerCell.swift
//  jQuiz
//
//  Created by Michael Page on 24/7/20.
//  Copyright © 2020 Jay Strawn. All rights reserved.
//

import UIKit

class AnswerCell: UITableViewCell {
    
    @IBOutlet weak var answerLabel: UILabel!
    
    func configure(for clue: Clue) {
        answerLabel.text = clue.answer
    }
    
}
