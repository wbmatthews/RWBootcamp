//
//  MediaPosts.swift
//  Birdie-Final
//
//  Created by Jay Strawn on 6/18/20.
//  Copyright © 2020 Jay Strawn. All rights reserved.
//

import UIKit

class MediaPostsHandler: NSObject {
    static let shared = MediaPostsHandler()
    var mediaPosts: [MediaPost] = []

    private override init() {}

    func getPosts() {
        let imagePost1 = ImagePost(textBody: "I love debugging software!", userName: "Jay", timestamp: Date(timeIntervalSinceNow: -123456), image: UIImage(named: "chop")!)
        let imagePost2 = ImagePost(textBody: "Went to the Aquarium today :]", userName: "Audrey", timestamp: Date(timeIntervalSinceNow: -9876), image: UIImage(named: "octopus")!)
        let textPost1 = TextPost(textBody: "Hello World!", userName: "Bhagat", timestamp: Date(timeIntervalSinceNow: -67890))
        let textPost2 = TextPost(textBody: "This is my favorite social media app! This is my favorite social media app! This is my favorite social media app!", userName: "Jeff", timestamp: Date(timeIntervalSinceNow: -2345))

        mediaPosts = [imagePost1, imagePost2, textPost1, textPost2]
        mediaPosts = mediaPosts.sorted(by: { $0.timestamp > $1.timestamp })
    }

    func addTextPost(textPost: TextPost) {
        mediaPosts.append(textPost)
        mediaPosts = mediaPosts.sorted(by: { $0.timestamp > $1.timestamp })
    }

    func addImagePost(imagePost: ImagePost) {
        mediaPosts.append(imagePost)
        mediaPosts = mediaPosts.sorted(by: { $0.timestamp > $1.timestamp })
    }

}
