//
//  JQuizGame.swift
//  jQuiz
//
//  Created by Michael Page on 25/7/20.
//  Copyright © 2020 Jay Strawn. All rights reserved.
//

import Foundation

enum JQuizGameError: Error {
    case networkIssue, invalidNumberOfUniqueClueAnswers
}

class JQuizGame {
    
    var round = 0
    
    func startNewRound(completion: @escaping (Result<[Clue], JQuizGameError>) -> Void) {
        Networking.sharedInstance.getAllCluesInRandomCategory { (result) in
            switch result {
            case .success(let clues):
                var filteredNumberOfClues: [Clue] = []
                do {
                    filteredNumberOfClues = try self.selectRandomClues(clues)
                } catch {
                    print("Unable to obtain enough unique answers!", error)
                    self.startNewRound() { (result) in
                        completion(result)
                    }
                }
                self.round += 1
                completion(.success(filteredNumberOfClues))
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(.networkIssue))
            }
        }
    }
    
    func selectRandomClues(_ clues: [Clue], numberOfClues: Int = 4) throws -> [Clue] {
        let cluesWithUniqueAnswersShuffled = filterCluesWithUniqueAnswers(clues).shuffled()
        
        guard let filteredNumberOfClues = filterNumberOfClues(numberOfClues, clues: cluesWithUniqueAnswersShuffled) else {
            // Category failed to provide the required number of clues with unique answers
            throw JQuizGameError.invalidNumberOfUniqueClueAnswers
        }
        return filteredNumberOfClues
    }
    
    func filterCluesWithUniqueAnswers(_ clues: [Clue]) -> [Clue] {
        // Remove clues with matching answer values
        let cluesWithUniqueAnswers = Array(Set(clues))
        return cluesWithUniqueAnswers
    }
    
    func filterNumberOfClues(_ numberOfClues: Int, clues: [Clue]) -> [Clue]? {
        guard clues.count >= numberOfClues else {
            return nil
        }
        return Array(clues[0..<numberOfClues])
    }
    
    func scorePlayerSelection(selectedClue: Clue, correctAnswerClue: Clue?) -> Int {
        guard selectedClue == correctAnswerClue else {
            return 0
        }
        return correctAnswerClue!.points ?? 100
    }
    
}
