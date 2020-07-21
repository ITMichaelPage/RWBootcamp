//
//  SandwichDetailViewController.swift
//  SandwichSaturation
//
//  Created by Michael Page on 21/7/20.
//  Copyright © 2020 Jeff Rames. All rights reserved.
//

import UIKit

class SandwichDetailViewController: UIViewController {
  
  var sandwich: Sandwich!
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var saturationDescriptionLabel: UILabel!
  @IBOutlet weak var imageView: UIImageView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    nameLabel.text = sandwich.name
    saturationDescriptionLabel.text = sandwich.sauceAmountModel.sauceAmount.description
    imageView.image = UIImage.init(imageLiteralResourceName: sandwich.imageName)
  }
  
}
