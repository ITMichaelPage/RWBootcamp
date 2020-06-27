//
//  TextPostModel.swift
//  Birdie
//
//  Created by Jay Strawn on 6/18/20.
//  Copyright © 2020 Jay Strawn. All rights reserved.
//

import UIKit

struct TextPost: MediaPost {
    var profileImage: UIImage {
        if let profileImage = UIImage(named: userName.lowercased()) {
            return profileImage
        } else {
            return UIImage(named: "default")!
        }
    }
    var textBody: String?
    var userName: String
    var timestamp: Date
}
