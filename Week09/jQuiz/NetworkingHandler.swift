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
  
  private let baseURL = "http://www.jservice.io/api/"
  private let randomClueURLsegment = "random"
  private let categoryURLSegment = "category?id="
  private let offsetURLsegment = "&offset="
    
  func getRandomCategory(completionHandler: @escaping (Int) -> ()) {
    
    guard let randomClueURL = URL(string: baseURL + randomClueURLsegment) else { return }
    let session = URLSession(configuration: .ephemeral)
    let task = session.dataTask(with: randomClueURL) { (data, response, error) in
      guard let httpResponse = response as? HTTPURLResponse,
        (200..<300).contains(httpResponse.statusCode) else {
          return
      }
      guard let data = data else { return }
      let decoder = JSONDecoder()
      
      do {
        if let clue = try decoder.decode([Clue].self, from: data).first {
          completionHandler(clue.categoryID)
        }
      } catch let error {
        print("Unable to process random seed clue, will try again. \(error)")
      }
    }
    task.resume()
  }
  
  func selectCluesFromCategory(id: Int, completionHandler: @escaping ([Clue], String) -> ()) {
    
    guard let categoryURL = URL(string: baseURL + categoryURLSegment + String(id)) else { return }
    let session = URLSession(configuration: .ephemeral)
    let task = session.dataTask(with: categoryURL) { (data, response, error) in
      guard let httpResponse = response as? HTTPURLResponse,
        (200..<300).contains(httpResponse.statusCode) else {
          return
      }
      guard let data = data else { return }
      let decoder = JSONDecoder()
      
      do {
        let category = try decoder.decode(Category.self, from: data)
        print("selected \(category.title): id:\(category.id)")
        let validClues = category.clues.filter { $0.question != nil && $0.answer != nil }
        let clues = Array<Clue>(validClues.shuffled().prefix(4))
        print("selected clue ids: \(clues.map { $0.id })")
        completionHandler(clues, category.title)

      } catch let error {
        print("Unable to decode category \(id): \(error)")
      }
    }
    task.resume()
  }
  
}
