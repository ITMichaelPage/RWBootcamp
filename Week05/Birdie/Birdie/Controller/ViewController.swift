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

    var selectedImage: UIImage?

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
        var userName: String?
        var textBody: String?

        let title = "Create Post"

        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)

        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            if let userName = userName, let textBody = textBody {

                if let selectedImage = self.selectedImage {
                    self.selectedImage = nil
                    let imagePost = ImagePost(textBody: textBody, userName: userName, timestamp: Date(), image: selectedImage)
                    MediaPostsHandler.shared.addImagePost(imagePost: imagePost)
                } else {
                    let textPost = TextPost(textBody: textBody, userName: userName, timestamp: Date())
                    MediaPostsHandler.shared.addTextPost(textPost: textPost)
                }

            }
            self.tableview.reloadData()
        }
        okAction.isEnabled = false

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
            self.selectedImage = nil
        }

        alert.addTextField { (textField) in
            textField.placeholder = "Username"
            textField.autocapitalizationType = .words

            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: .main) { _ in
                userName = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
                validateTextInput()
            }
        }

        alert.addTextField { (textField) in
            textField.placeholder = "Words of wisdom"
            textField.autocapitalizationType = .sentences

            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: .main) { _ in
                textBody = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
                validateTextInput()
            }
        }

        func validateTextInput() {
            let userNameCharacterCount = userName?.count ?? 0
            let textBodyCharacterCount = textBody?.count ?? 0

            okAction.isEnabled = (userNameCharacterCount > 0) && (textBodyCharacterCount > 0)
        }

        alert.addAction(cancelAction)
        alert.addAction(okAction)

        present(alert, animated: true, completion: nil)
    }

    @IBAction func didPressCreateTextPostButton(_ sender: Any) {
        presentCreatePostAlert()
    }

    @IBAction func didPressCreateImagePostButton(_ sender: Any) {
        presentImagePicker()
    }

}

extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mediaPosts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return MediaPostsViewModel.shared.setupTableViewCell(for: mediaPosts[indexPath.row], in: tableView)
    }

}

extension ViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func presentImagePicker() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = false
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
            picker.modalPresentationStyle = .fullScreen
        }
        present(picker, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] {
            selectedImage = image as? UIImage
            dismiss(animated: true) {
                self.presentCreatePostAlert()
            }
        }
    }

}
