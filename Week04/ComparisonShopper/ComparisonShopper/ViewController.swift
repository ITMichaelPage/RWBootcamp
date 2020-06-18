//
//  ViewController.swift
//  ComparisonShopper
//
//  Created by Jay Strawn on 6/15/20.
//  Copyright © 2020 Jay Strawn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // Left
    @IBOutlet weak var titleLabelLeft: UILabel!
    @IBOutlet weak var imageViewLeft: UIImageView!
    @IBOutlet weak var priceLabelLeft: UILabel!
    @IBOutlet weak var roomLabelLeft: UILabel!

    // Right
    @IBOutlet weak var titleLabelRight: UILabel!
    @IBOutlet weak var imageViewRight: UIImageView!
    @IBOutlet weak var priceLabelRight: UILabel!
    @IBOutlet weak var roomLabelRight: UILabel!

    var house1: House?
    var house2: House?

    override func viewDidLoad() {
        super.viewDidLoad()
        house1 = House()
        house1?.price = "$12,000"
        house1?.bedrooms = "3 bedrooms"
        setUpLeftSideUI()
        setUpRightSideUI()
    }

    enum Side {
        case left, right
    }
    
    func updateSideUIVisibility(_ side: Side, hide: Bool) {
        let alpha: CGFloat = hide ? 0 : 1
        switch side {
        case .left:
            titleLabelLeft.alpha = alpha
            imageViewLeft.alpha = alpha
            priceLabelLeft.alpha = alpha
            roomLabelLeft.alpha = alpha
        case .right:
            titleLabelRight.alpha = alpha
            imageViewRight.alpha = alpha
            priceLabelRight.alpha = alpha
            roomLabelRight.alpha = alpha
        }
    }
    
    func setUpLeftSideUI() {
        guard let house1 = house1 else {
            updateSideUIVisibility(.left, hide: true)
            return
        }
        
        updateSideUIVisibility(.left, hide: false)
        titleLabelLeft.text = house1.address
        priceLabelLeft.text = house1.price
        roomLabelLeft.text = house1.bedrooms
    }
    
    func setUpRightSideUI() {
        guard let house2 = house2 else {
            updateSideUIVisibility(.right, hide: true)
            return
        }

        updateSideUIVisibility(.right, hide: false)
        titleLabelRight.text = house2.address
        priceLabelRight.text = house2.price
        roomLabelRight.text = house2.bedrooms
    }

    @IBAction func didPressAddRightHouseButton(_ sender: Any) {
        openAlertView()
    }

    func openAlertView() {
        let alert = UIAlertController(title: "Alert Title", message: "Alert Message", preferredStyle: UIAlertController.Style.alert)

        alert.addTextField { (textField) in
            textField.placeholder = "address"
        }

        alert.addTextField { (textField) in
            textField.placeholder = "price"
        }

        alert.addTextField { (textField) in
            textField.placeholder = "bedrooms"
        }

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:nil))

        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler:{ (UIAlertAction) in
            var house = House()
            house.address = alert.textFields?[0].text
            house.price = alert.textFields?[1].text
            house.bedrooms = alert.textFields?[2].text
            self.house2 = house
            self.setUpRightSideUI()
        }))

        self.present(alert, animated: true, completion: nil)
    }

}

struct House {
    var address: String?
    var price: String?
    var bedrooms: String?
}

