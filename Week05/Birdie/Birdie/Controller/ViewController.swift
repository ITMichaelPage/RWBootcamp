//
//  ViewController.swift
//  Birdie
//
//  Created by Jay Strawn on 6/18/20.
//  Copyright © 2020 Jay Strawn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var mediaPosts: [MediaPost] {
        return MediaPostsHandler.shared.mediaPosts
    }

    @IBOutlet weak var tableview: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        MediaPostsHandler.shared.getPosts()
        setUpTableView()
    }

    func setUpTableView() {
        // Set delegates, register custom cells, set up datasource, etc.
        registerTableViewCells(tableView: tableview, cellIdentifiers: [.textPostCell, .imagePostCell])
    }

    @IBAction func didPressCreateTextPostButton(_ sender: Any) {

    }

    @IBAction func didPressCreateImagePostButton(_ sender: Any) {

    }

}

extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mediaPosts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let textPost = mediaPosts[indexPath.row] as? TextPost {
            if let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifier.textPostCell.rawValue, for: indexPath) as? TextPostCell {
                cell.configure(for: textPost)
                return cell
            }
        } else if let imagePost = mediaPosts[indexPath.row] as? ImagePost {
            if let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifier.imagePostCell.rawValue, for: indexPath) as? ImagePostCell {
                cell.configure(for: imagePost)
                return cell
            }
        }
        // Fallback value
        return UITableViewCell()
    }

}

extension ViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
