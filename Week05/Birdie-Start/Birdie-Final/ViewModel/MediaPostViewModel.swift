//
//  MediaPostViewModel.swift
//  Birdie-Final
//
//  Created by Bill Matthews on 2020-06-29.
//  Copyright © 2020 Jay Strawn. All rights reserved.
//

import Foundation
import UIKit

class MediaPostViewModel {
  
  var numberOfCells: Int {
    MediaPostsHandler.shared.mediaPosts.count
  }
  
  func cellForPost(_ post: MediaPost, in tableView: UITableView) -> UITableViewCell {
    switch post {
    case is TextPost:
      guard let newCell = tableView.dequeueReusableCell(withIdentifier: "textPostCell") as? TextPostCell else { return UITableViewCell() }
      newCell.userNameLabel.text = post.userName
      newCell.timestampLabel.text = formatDate(post.timestamp)
      newCell.textBodyLabel.text = post.textBody
      return newCell
    case is ImagePost:
      let post = post as! ImagePost
      guard let newCell = tableView.dequeueReusableCell(withIdentifier: "imagePostCell") as? ImagePostCell else { return UITableViewCell() }
      newCell.userNameLabel.text = post.userName
      newCell.timestampLabel.text = formatDate(post.timestamp)
      newCell.textBodyLabel.text = post.textBody
      newCell.postImage.image = post.image
      return newCell
    default:
      print("Post is of unknown type")
      return UITableViewCell()
    }
  }
  
  private func formatDate(_ date: Date) -> String {
    let postDateFormatter = DateFormatter()
    postDateFormatter.dateFormat = "MMM dd h:mm a"
    return postDateFormatter.string(from: date)
  }
  
  
  
}

