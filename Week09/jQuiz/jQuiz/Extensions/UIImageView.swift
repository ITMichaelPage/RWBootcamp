//
//  UIImageView.swift
//  jQuiz
//
//  Created by Michael Page on 27/7/20.
//  Copyright © 2020 Jay Strawn. All rights reserved.
//

import UIKit

extension UIImageView {
    public static var imageStore: [String: UIImage] = [:]

    public class func image(url: URL, completion: @escaping (UIImage) -> Void) {
        let key = String(url.hashValue)
        if let image = imageStore[key] {
            completion(image)
        }
        Networking.sharedInstance.getImage(url: url) { (image) in
            imageStore[key] = image
            completion(image)
        }
    }
}
