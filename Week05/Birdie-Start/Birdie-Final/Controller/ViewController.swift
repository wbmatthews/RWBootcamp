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
  
  let mediaPostViewModel = MediaPostViewModel()
  var imageSelectedFromPicker: UIImage?
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
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
    
    MediaPostsHandler.shared.getPosts()
    
  }
  
  @IBAction func didPressCreateTextPostButton(_ sender: Any) {
    createNewPost()
  }
  
  @IBAction func didPressCreateImagePostButton(_ sender: Any) {
    let picker = UIImagePickerController()
    picker.delegate = self
    if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
      picker.sourceType = .photoLibrary
      picker.modalPresentationStyle = .fullScreen
      present(picker, animated: true, completion: nil)
    }

  }
  
  func createNewPost() {

    let newPostEntry = UIAlertController(title: imageSelectedFromPicker == nil ? "New Text Post" : "New Image Post", message: nil, preferredStyle: .alert)
    
    newPostEntry.addTextField { (userNameField) in
      userNameField.placeholder = "User name"
      userNameField.autocapitalizationType = .words
    }
    newPostEntry.addTextField { (bodyTextfield) in
      bodyTextfield.placeholder = "Enter post here"
    }
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    let postAction = UIAlertAction(title: "Post", style: .default) { (alert) in
      if let textFields = newPostEntry.textFields, let userName = textFields[0].text, let postBody = textFields[1].text {
        if let image = self.imageSelectedFromPicker {
          MediaPostsHandler.shared.addImagePost(imagePost: ImagePost(textBody: postBody, userName: userName, timestamp: Date(), image: image))
          self.imageSelectedFromPicker = nil
        } else {
          MediaPostsHandler.shared.addTextPost(textPost: TextPost(textBody: postBody, userName: userName, timestamp: Date()))
        }
        self.tableview.reloadData()
      }
    }
    newPostEntry.addAction(cancelAction)
    newPostEntry.addAction(postAction)
    
    present(newPostEntry, animated: true, completion: nil)
  }
  
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    mediaPostViewModel.numberOfCells
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let post = MediaPostsHandler.shared.mediaPosts[indexPath.row]
    return mediaPostViewModel.cellForPost(post, in: tableView)
  }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    if let image = info[.originalImage] as? UIImage {
      imageSelectedFromPicker = image
    }
    dismiss(animated: true, completion: nil)
    createNewPost()
  }
}



