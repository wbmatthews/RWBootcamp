//
//  ImagePostCell.swift
//  Birdie-Final
//
//  Created by Bill Matthews on 2020-06-26.
//  Copyright © 2020 Jay Strawn. All rights reserved.
//

import UIKit

class ImagePostCell: UITableViewCell {

  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var timestampLabel: UILabel!
  @IBOutlet weak var textBodyLabel: UILabel!
  @IBOutlet weak var postImage: UIImageView!
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
