/// Copyright (c) 2020 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

class HomeViewController: UIViewController{

  @IBOutlet weak var headingLabel: UILabel!
  @IBOutlet weak var themeSwitch: UISwitch!
  
  @IBOutlet var widgetViews: [CryptoWidgetView]!
  @IBOutlet var widgetViewTextLabels: [UILabel]!
  
  let cryptoData = DataGenerator.shared.generateData()
  let commaConcatCryptoNames: (String, CryptoCurrency) -> String = { result, thisCrypto in
    if result != "" {
      return result + ", " + thisCrypto.name
    } else {
      return thisCrypto.name
    }
  }
    
  override func viewDidLoad() {
    super.viewDidLoad()

    setupLabels()
    setView1Data()
    setView2Data()
    setView3Data()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    registerForTheme()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    unregisterForTheme()
  }
  
  func setupLabels() {
    headingLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
    widgetViewTextLabels.forEach { $0.font = UIFont.systemFont(ofSize: 18, weight: .regular) }
  }
  
  func setView1Data() {
    guard let cryptoData = cryptoData else { return }
    let allCurrencyNames = cryptoData.reduce("", commaConcatCryptoNames)
    widgetViewTextLabels[0].text = allCurrencyNames
  }
  
  func setView2Data() {
    guard let cryptoData = cryptoData else { return }
    let increasingCurrencyNames = cryptoData.filter { $0.currentValue > $0.previousValue }.reduce("", commaConcatCryptoNames)
    widgetViewTextLabels[1].text = increasingCurrencyNames
  }
  
  func setView3Data() {
    guard let cryptoData = cryptoData else { return }
    let decreasingCurrencyNames = cryptoData.filter { $0.currentValue < $0.previousValue }.reduce("", commaConcatCryptoNames)
    widgetViewTextLabels[2].text = decreasingCurrencyNames
  }
  
  @IBAction func switchPressed(_ sender: Any) {
    ThemeManager.shared.set(theme: themeSwitch.isOn ? DarkTheme() : LightTheme())
  }
}

extension HomeViewController: Themeable {
  func registerForTheme() {
    NotificationCenter.default.addObserver(self, selector: #selector(themeChanged), name: ThemeManager.themeChangeNotification, object: nil)
  }
  
  func unregisterForTheme() {
    NotificationCenter.default.removeObserver(self)
  }
  
  @objc func themeChanged() {
    guard let theme = ThemeManager.shared.currentTheme else { return }
    
    widgetViews.forEach { $0.backgroundColor = theme.widgetColor }
    widgetViews.forEach { $0.layer.borderColor = theme.borderColor.cgColor }
    
    widgetViewTextLabels.forEach { $0.textColor = theme.textColor }
    self.view.backgroundColor = theme.backgroundColor
    
    headingLabel.textColor = theme.textColor
  }
  
  
}
