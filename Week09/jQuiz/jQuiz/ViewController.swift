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
    @IBOutlet weak var scoreLabel: UILabel!
    
    var clues: [Clue] = []
    var correctAnswerClue: Clue?
    var points: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        
        self.scoreLabel.text = "\(self.points)"
        
        if SoundManager.shared.isSoundEnabled == false {
            soundButton.setImage(UIImage(systemName: "speaker.slash"), for: .normal)
        } else {
            soundButton.setImage(UIImage(systemName: "speaker"), for: .normal)
        }
        
        SoundManager.shared.playSound()
        
        getClues()
    }
    
    @IBAction func didPressVolumeButton(_ sender: Any) {
        SoundManager.shared.toggleSoundPreference()
        if SoundManager.shared.isSoundEnabled == false {
            soundButton.setImage(UIImage(systemName: "speaker.slash"), for: .normal)
        } else {
            soundButton.setImage(UIImage(systemName: "speaker"), for: .normal)
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
        
    }
    
}

extension ViewController {
    
    func updateView() {
        selectRandomClues(numberOfClues: 4)
        categoryLabel.text = correctAnswerClue?.category.title
        clueLabel.text = correctAnswerClue?.question
        tableView.reloadData()
    }
    
    func getClues() {
        Networking.sharedInstance.getRandomCategoryID { (categoryID) in
            Networking.sharedInstance.getAllCluesForCategoryID(categoryID) { (clues) in
                self.clues = clues
                DispatchQueue.main.async {
                    self.updateView()
                }
            }
        }
    }
    
    func selectRandomClues(numberOfClues: Int) {
        guard let randomClues = filterCluesWithUniqueAnswers(numberOfClues: numberOfClues) else {
            // Category failed to provide the required number of clues with unique answers
            getClues()
            return
        }
        clues = randomClues
        correctAnswerClue = clues.randomElement()
        print(correctAnswerClue?.answer)
    }
    
    func filterCluesWithUniqueAnswers(numberOfClues: Int) -> [Clue]? {
        // Remove clues with matching answer values
        let cluesWithUniqueAnswers = Array(Set(clues))
        guard cluesWithUniqueAnswers.count >= numberOfClues else {
            return nil
        }
        let shuffledSubsetOfClues = Array(cluesWithUniqueAnswers.shuffled()[0..<numberOfClues])
        return shuffledSubsetOfClues
    }
    
}
