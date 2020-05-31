//
//  InfoViewController.swift
//  ColorPicker
//
//  Created by Michael Page on 31/5/20.
//  Copyright © 2020 Michael Page. All rights reserved.
//

import UIKit
import WebKit

class InfoViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let url = URL(string: "https://en.wikipedia.org/wiki/RGB_color_model") {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }

    @IBAction func close() {
      dismiss(animated: true, completion: nil)
    }

}
