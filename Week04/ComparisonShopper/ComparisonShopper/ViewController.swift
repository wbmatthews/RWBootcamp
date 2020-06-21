//
//  ViewController.swift
//  ComparisonShopper
//
//  Created by Jay Strawn on 6/15/20.
//  Copyright © 2020 Jay Strawn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  enum MissingHouseAttributeMessage: String {
    case noAddress = "Unlisted address"
    case noPrice = "Call for price"
    case noRooms = "Bedrooms not listed"
  }

    // Left
    @IBOutlet weak var titleLabelLeft: UILabel!
    @IBOutlet weak var imageViewLeft: UIImageView!
    @IBOutlet weak var priceLabelLeft: UILabel!
    @IBOutlet weak var roomLabelLeft: UILabel!

    // Right
    @IBOutlet weak var titleLabelRight: UILabel!
    @IBOutlet weak var imageViewRight: UIImageView!
    @IBOutlet weak var priceLabelRight: UILabel!
    @IBOutlet weak var roomLabelRight: UILabel!

    var house1: House?
    var house2: House?

    override func viewDidLoad() {
        super.viewDidLoad()
      
      house1 = House(address: "123 Abc St.", price: "$12,000", bedrooms: "3 bedrooms")
      
        setUpLeftSideUI()
        setUpRightSideUI()

//        house1?.price = "$12,000"
//        house1?.bedrooms = "3 bedrooms"
    }

    func setUpLeftSideUI() {
      guard let house = house1 else { return }
      titleLabelLeft.text = house.address ?? MissingHouseAttributeMessage.noAddress.rawValue
      priceLabelLeft.text = house.price ?? MissingHouseAttributeMessage.noPrice.rawValue
      roomLabelLeft.text = house.bedrooms ?? MissingHouseAttributeMessage.noRooms.rawValue
  }

    func setUpRightSideUI() {
      guard let house = house2 else {
        toggleRightSideUI(isHidden: true)
        return
      }
      toggleRightSideUI(isHidden: false)
      if let address = house.address {
        titleLabelRight.text = (address != "" ? address : MissingHouseAttributeMessage.noAddress.rawValue)
      } else {
        titleLabelRight.text = MissingHouseAttributeMessage.noAddress.rawValue
      }
      
      if let price = house.price {
        priceLabelRight.text = (price != "" ? price : MissingHouseAttributeMessage.noPrice.rawValue)
      } else {
        priceLabelRight.text = MissingHouseAttributeMessage.noPrice.rawValue
      }
      
      if let rooms = house.bedrooms {
        roomLabelRight.text = (rooms != "" ? rooms : MissingHouseAttributeMessage.noRooms.rawValue)
      } else {
        roomLabelRight.text = MissingHouseAttributeMessage.noRooms.rawValue
      }
      
    }
  
  func toggleRightSideUI(isHidden: Bool) {
    titleLabelRight.isHidden = isHidden
    imageViewRight.isHidden = isHidden
    priceLabelRight.isHidden = isHidden
    roomLabelRight.isHidden = isHidden
  }

    @IBAction func didPressAddRightHouseButton(_ sender: Any) {
        openAlertView()
    }

    func openAlertView() {
        let alert = UIAlertController(title: "Alert Title", message: "Alert Message", preferredStyle: UIAlertController.Style.alert)

        alert.addTextField { (textField) in
            textField.placeholder = "address"
        }

        alert.addTextField { (textField) in
            textField.placeholder = "price"
        }

        alert.addTextField { (textField) in
            textField.placeholder = "bedrooms"
        }

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:nil))

        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler:{ (UIAlertAction) in
            var house = House()
            house.address = alert.textFields?[0].text
            house.price = alert.textFields?[1].text
            house.bedrooms = alert.textFields?[2].text
            self.house2 = house
            self.setUpRightSideUI()
        }))

        self.present(alert, animated: true, completion: nil)
    }

}

struct House {
    var address: String?
    var price: String?
    var bedrooms: String?
}

