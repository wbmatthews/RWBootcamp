//
//  InfoViewController.swift
//  HueChoose
//
//  Created by Bill Matthews on 2020-05-31.
//  Copyright © 2020 Bill Matthews. All rights reserved.
//

import UIKit
import WebKit

class InfoViewController: UIViewController, WKUIDelegate {
  
  @IBOutlet var webView: WKWebView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
      let webURL = URL(string: "https://en.wikipedia.org/wiki/RGB_color_model")
      let webRequest = URLRequest(url: webURL!)
      webView.load(webRequest)
    }
  
  @IBAction func close() {
    dismiss(animated: true, completion: nil)
  }
  
}
