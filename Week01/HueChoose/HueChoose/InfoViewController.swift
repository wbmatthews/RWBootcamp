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
  var mode: ViewController.ColourMode?
  
    override func viewDidLoad() {
        super.viewDidLoad()
      let webURL = URL(string: mode == .rgb ? "https://en.wikipedia.org/wiki/RGB_color_model" : "https://en.wikipedia.org/wiki/HSL_and_HSV")
      let webRequest = URLRequest(url: webURL!)
      webView.load(webRequest)
    }
  
  @IBAction func close() {
    dismiss(animated: true, completion: nil)
  }
  
}
