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
    
    let newTextPostEntry = UIAlertController(title: "New Text Post", message: nil, preferredStyle: .alert)
    
    newTextPostEntry.addTextField { (userNameField) in
      userNameField.placeholder = "User name"
      userNameField.autocapitalizationType = .words
    }
    newTextPostEntry.addTextField { (bodyTextfield) in
      bodyTextfield.placeholder = "Enter post here"
    }
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    let postAction = UIAlertAction(title: "Post", style: .default) { (alert) in
      if let textFields = newTextPostEntry.textFields, let userName = textFields[0].text, let postBody = textFields[1].text {
        MediaPostsHandler.shared.addTextPost(textPost: TextPost(textBody: postBody, userName: userName, timestamp: Date()))
        self.tableview.reloadData()
      }
    }
    newTextPostEntry.addAction(cancelAction)
    newTextPostEntry.addAction(postAction)
    
    present(newTextPostEntry, animated: true, completion: nil)
  }

    @IBAction func didPressCreateImagePostButton(_ sender: Any) {
      let picker = UIImagePickerController()
      picker.delegate = self
      picker.sourceType = .photoLibrary
      picker.modalPresentationStyle = .fullScreen
      present(picker, animated: true, completion: nil)
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    MediaPostsHandler.shared.mediaPosts.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let post = MediaPostsHandler.shared.mediaPosts[indexPath.row]
    
    if post is TextPost {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "textPostCell", for: indexPath) as? TextPostCell else { return UITableViewCell() }
      cell.userNameLabel.text = post.userName
      cell.timestampLabel.text = formatDate(post.timestamp)
      cell.textBodyLabel.text = post.textBody
      return cell
    } else if post is ImagePost {
      let imagePost = post as! ImagePost
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "imagePostCell", for: indexPath) as? ImagePostCell else { return UITableViewCell() }
      cell.userNameLabel.text = imagePost.userName
      cell.timestampLabel.text = formatDate(imagePost.timestamp)
      cell.textBodyLabel.text = imagePost.textBody
      cell.postImage.image = imagePost.image
      return cell
    } else {
      return UITableViewCell()
    }
  }
}

extension ViewController {
  func formatDate(_ date: Date) -> String {
    let postDateFormatter = DateFormatter()
    postDateFormatter.dateFormat = "MMM dd, yyyy HH:mm:ss"
    return postDateFormatter.string(from: date)
  }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
  }
}



