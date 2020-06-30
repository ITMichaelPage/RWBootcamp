//
//  MediaPostsViewModel.swift
//  Birdie
//
//  Created by Michael Page on 27/6/20.
//  Copyright © 2020 Jay Strawn. All rights reserved.
//

import UIKit

class MediaPostsViewModel {

    static let shared = MediaPostsViewModel()

    func setupTableViewCell(for post: MediaPost, in tableView: UITableView) -> UITableViewCell {
        if let textPost = post as? TextPost {
            if let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifier.textPostCell.rawValue) as? TextPostCell {
                cell.configure(for: textPost)
                return cell
            }
        } else if let imagePost = post as? ImagePost {
            if let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifier.imagePostCell.rawValue) as? ImagePostCell {
                cell.configure(for: imagePost)
                return cell
            }
        }
        // Fallback value
        return UITableViewCell()
    }

}
