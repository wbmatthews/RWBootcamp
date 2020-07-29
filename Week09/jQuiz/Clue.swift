//
//  QuestionCodable.swift
//  jQuiz
//
//  Created by Jay Strawn on 7/17/20.
//  Copyright © 2020 Jay Strawn. All rights reserved.
//

import Foundation

struct Clue: Decodable {
  
  enum CodingKeys: String, CodingKey {
//    case id,
    case answer, question, value
    case categoryID = "category_id"
  }
  
//  let id: Int
  let answer: String
  let question: String
  let value: Int
  let categoryID: Int
//  let category: Category
}

struct Category: Decodable {
  
  enum CodingKeys: String, CodingKey {
    case id, title, clues
    case cluesCount = "clues_count"
  }
  
  let id: Int
  let title: String
  let cluesCount: Int
  let clues: [Clue]
}

//extension Category {
//  init?(json: [String: Any]) {
//    guard let id = json["id"] as? Int, let title = json["title"] as? String, let cluesCount = json["clues_count"] as? Int else { return nil }
//    
//    self.id = id
//    self.title = title
//    self.cluesCount = cluesCount
//  }
//}
