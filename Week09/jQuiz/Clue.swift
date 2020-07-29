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
    case id, answer, question, value
    case categoryID = "category_id"
  }
  
  let id: Int
  let answer: String?
  let question: String?
  let value: Int?
  let categoryID: Int
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

