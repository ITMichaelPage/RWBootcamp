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

    override func awakeFromNib() {
        super.awakeFromNib()
        setupProfileImage()
    }

    func configure(for post: TextPost) {
        profileImageView.image = post.profileImage
        userNameLabel.text = post.userName
        timestampLabel.text = post.timestamp.asString(format: "d MMM, HH:mm")
        textBodyLabel.text = post.textBody
    }

    private func setupProfileImage() {
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileImageView.layer.borderColor = #colorLiteral(red: 0.8820986675, green: 0.8820986675, blue: 0.8820986675, alpha: 1)
        profileImageView.layer.borderWidth = 2
    }

}
