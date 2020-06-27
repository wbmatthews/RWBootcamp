//
//  ViewController.swift
//  Birdie-Final
//
//  Created by Jay Strawn on 6/18/20.
//  Copyright © 2020 Jay Strawn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
      MediaPostsHandler.shared.getPosts()
        setUpTableView()
    }

    func setUpTableView() {
        // Set delegates, register custom cells, set up datasource, etc.
      tableview.delegate = self
      tableview.dataSource = self
      let textPostCell = UINib(nibName: "TextPostCell", bundle: nil)
      let imagePostCell = UINib(nibName: "ImagePostCell", bundle: nil)

      tableview.register(textPostCell, forCellReuseIdentifier: "textPostCell")
      tableview.register(imagePostCell, forCellReuseIdentifier: "imagePostCell")
      
    }

    @IBAction func didPressCreateTextPostButton(_ sender: Any) {

    }

    @IBAction func didPressCreateImagePostButton(_ sender: Any) {

    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    MediaPostsHandler.shared.mediaPosts.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let post = MediaPostsHandler.shared.mediaPosts[indexPath.row]
    let postDateFormatter = DateFormatter()
    postDateFormatter.dateFormat = "MMM dd, yyyy HH:mm:ss"
    
    if post is TextPost {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "textPostCell", for: indexPath) as? TextPostCell else { return UITableViewCell() }
      cell.userNameLabel.text = post.userName
      cell.timestampLabel.text = postDateFormatter.string(from: post.timestamp)
      cell.textBodyLabel.text = post.textBody
      return cell
    } else {
      let imagePost = post as! ImagePost
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "imagePostCell", for: indexPath) as? ImagePostCell else { return UITableViewCell() }
      cell.userNameLabel.text = imagePost.userName
      cell.timestampLabel.text = postDateFormatter.string(from: imagePost.timestamp)
      cell.textBodyLabel.text = imagePost.textBody
      cell.postImage.image = imagePost.image
      return cell
    }
  }
  
  
}


