//
//  ViewController.swift
//  jQuiz
//
//  Created by Jay Strawn on 7/17/20.
//  Copyright © 2020 Jay Strawn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var soundButton: UIButton!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var clueLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var potentialPointsLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    let game = JQuizGame()
    var clues: [Clue] = []
    var correctAnswerClue: Clue?
    var points: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        getLogoImage()
        updateQuestion()
        
        if SoundManager.shared.isSoundEnabled == false {
            soundButton.setImage(UIImage(systemName: "speaker.slash"), for: .normal)
        } else {
            soundButton.setImage(UIImage(systemName: "speaker"), for: .normal)
            SoundManager.shared.playSound()
        }
    }
    
    @IBAction func didPressVolumeButton(_ sender: Any) {
        SoundManager.shared.toggleSoundPreference()
        if SoundManager.shared.isSoundEnabled == false {
            soundButton.setImage(UIImage(systemName: "speaker.slash"), for: .normal)
        } else {
            soundButton.setImage(UIImage(systemName: "speaker"), for: .normal)
        }
    }
    
    func getLogoImage() {
        let logoImageURLString = "https://cdn1.edgedatg.com/aws/v2/abc/ABCUpdates/blog/2900129/8484c3386d4378d7c826e3f3690b481b/1600x900-Q90_8484c3386d4378d7c826e3f3690b481b.jpg"
        
        guard let logoImageURL = URL(string: logoImageURLString) else {
            return
        }
        
        UIImageView.image(url: logoImageURL) { (image) in
            DispatchQueue.main.async {
                self.logoImageView.image = image
            }
        }
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        registerTableViewCells(tableView: tableView, cellIdentifiers: [.answerCell])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clues.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifier.answerCell.rawValue) as? AnswerCell {
            cell.configure(for: clues[indexPath.row])
            return cell
        } else {
            fatalError("Unable to configure cell!")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedClue = clues[indexPath.row]
        points += game.scorePlayerSelection(selectedClue: selectedClue, correctAnswerClue: correctAnswerClue)
        updateQuestion()
    }
    
}

extension ViewController {
    
    func updateQuestion() {
        game.startNewRound() { (result) in
            switch result {
            case .success(let clues):
                DispatchQueue.main.async {
                    self.clues = clues
                    self.correctAnswerClue = clues.randomElement()
                    self.categoryLabel.text = self.correctAnswerClue?.category.title
                    self.potentialPointsLabel.text = "FOR \(self.correctAnswerClue?.points ?? 0) POINTS"
                    self.clueLabel.text = self.correctAnswerClue?.question
                    self.scoreLabel.text = self.points.withCommas()
                    self.tableView.reloadData()
                    
                    if let correctAnswerClue = self.correctAnswerClue {
                        print("Answer: \(correctAnswerClue.answer) | Points: \(correctAnswerClue.points)")
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
                DispatchQueue.main.async{
                    let failureAlert = UIAlertController(title: "Connection Error", message: "Please check your Internet connection and try again.", preferredStyle: .alert)
                    failureAlert.addAction(UIAlertAction(title:"OK", style: .cancel, handler: nil))
                    self.present(failureAlert, animated: true, completion: nil)
                }
            }
        }
    }
    
}
