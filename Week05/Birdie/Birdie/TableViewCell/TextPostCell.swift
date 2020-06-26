//
//  TextPostCell.swift
//  Birdie
//
//  Created by Michael Page on 25/6/20.
//  Copyright © 2020 Jay Strawn. All rights reserved.
//

import UIKit

class TextPostCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var textBodyLabel: UILabel!

    func configure(for post: TextPost) {
        userNameLabel.text = post.userName
        timestampLabel.text = post.timestamp.asString(format: "d MMM, HH:mm")
        textBodyLabel.text = post.textBody
    }

}
