//
//  NetworkingHandler.swift
//  jQuiz
//
//  Created by Jay Strawn on 7/17/20.
//  Copyright © 2020 Jay Strawn. All rights reserved.
//

import Foundation

class Networking {
    
    static let sharedInstance = Networking()
    
    let apiBaseURL = URL(string: "https://jservice.io/api")!
    
    func getRandomCategoryID(completion: @escaping (Int) -> Void) {
        let randomClueURL = apiBaseURL.appendingPathComponent("random")
        
        let task = URLSession.shared.dataTask(with: randomClueURL) { (data, response, error) in
            guard let dataResponse = data, error == nil else {
                print(error?.localizedDescription ?? "Response Error")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let randomClue = try decoder.decode([Clue].self, from: dataResponse).first
                guard let randomCategoryID = randomClue?.categoryID else {
                    print("Error", "Response did not contain a clue!")
                    return
                }
                completion(randomCategoryID)
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
    }
    
    func getAllCluesForCategoryID(_ categoryID: Int, completion: @escaping ([Clue]) -> Void) {
        var urlComponents = URLComponents(url: apiBaseURL, resolvingAgainstBaseURL: false)!
        urlComponents.path = "/api/clues"
        urlComponents.queryItems = [
            URLQueryItem(name: "category", value: String(categoryID))
        ]
        
        guard let cluesURL = urlComponents.url else {
            print("Error", "Failed to build valid URL!")
            return
        }
        
        let task = URLSession.shared.dataTask(with: cluesURL) { (data, response, error) in
            guard let dataResponse = data, error == nil else {
                print(error?.localizedDescription ?? "Response Error")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let clues = try decoder.decode([Clue].self, from: dataResponse)
                completion(clues)
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
    }
    
}
