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

    func presentCreatePostAlert() {
        let title = "Create Post"

        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "Username"
            textField.autocapitalizationType = .words
        })

        alert.addTextField { (textField) in
            textField.placeholder = "Words of wisdom"
            textField.autocapitalizationType = .sentences
        }

        let action = UIAlertAction(title: "OK", style: .default, handler: { action in
            if let userName = alert.textFields?[0].text, let textBody = alert.textFields?[1].text {
                let textPost = TextPost(textBody: textBody, userName: userName, timestamp: Date())
                MediaPostsHandler.shared.addTextPost(textPost: textPost)
            }
            self.tableview.reloadData()
        })

        alert.addAction(action)

        present(alert, animated: true, completion: nil)
    }

    @IBAction func didPressCreateTextPostButton(_ sender: Any) {
        presentCreatePostAlert()
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
