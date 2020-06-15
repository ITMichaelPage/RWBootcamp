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

  @IBOutlet weak var view1: SummaryView!
  @IBOutlet weak var view2: SummaryView!
  @IBOutlet weak var view3: SummaryView!
  @IBOutlet weak var mostFallingView: SummaryView!
  @IBOutlet weak var mostRisingView: SummaryView!
  @IBOutlet weak var headingLabel: UILabel!
  @IBOutlet weak var view1TextLabel: UILabel!
  @IBOutlet weak var view2TextLabel: UILabel!
  @IBOutlet weak var view3TextLabel: UILabel!
  @IBOutlet weak var mostFallingHeadingLabel: UILabel!
  @IBOutlet weak var mostFallingValueLabel: UILabel!
  @IBOutlet weak var mostRisingHeadingLabel: UILabel!
  @IBOutlet weak var mostRisingValueLabel: UILabel!
  @IBOutlet weak var themeSwitch: UISwitch!
  
  let cryptoData = DataGenerator.shared.generateData()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupLabels()
    setView1Data()
    setView2Data()
    setView3Data()
    setMostFallingData()
    setMostRisingData()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    registerForTheme()
    // Display LightTheme be default
    ThemeManager.shared.set(theme: LightTheme())
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    unregisterForTheme()
  }
  
  func setupLabels() {
    headingLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
    view1TextLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
    view2TextLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
  }
  
  func setView1Data() {
    let ownedCryptoCurrencyNames = cryptoData?.reduce("") { (result, cryptoCurrency) in
      result == "" ? cryptoCurrency.name : result + ", " + cryptoCurrency.name
    }
    view1TextLabel.text = ownedCryptoCurrencyNames
  }
  
  func setView2Data() {
    let increasedValueCryptoCurrencyNames = cryptoData?.filter{
      $0.currentValue > $0.previousValue
    }.reduce("") { (result, cryptoCurrency) in
      result == "" ? cryptoCurrency.name : result + ", " + cryptoCurrency.name
    }
    view2TextLabel.text = increasedValueCryptoCurrencyNames
  }
  
  func setView3Data() {
    let decreasedValueCryptoCurrencyNames = cryptoData?.filter{
        $0.currentValue < $0.previousValue
      }.reduce("") { (result, cryptoCurrency) in
        result == "" ? cryptoCurrency.name : result + ", " + cryptoCurrency.name
      }
    view3TextLabel.text = decreasedValueCryptoCurrencyNames
  }
  
  func setMostFallingData() {
    let mostFallingCryptoCurrency = cryptoData?.filter {
      $0.trend == .falling
    }.max(by: { $0.valueRise > $1.valueRise })
    
    guard mostFallingCryptoCurrency != nil else {
      mostFallingValueLabel.text = "N/A"
      return
    }
    mostFallingValueLabel.text = String(format: "%.1f", mostFallingCryptoCurrency!.valueRise)
  }
  
  func setMostRisingData() {
    let mostRisingCryptoCurrency = cryptoData?.filter {
      $0.trend == .rising
    }.max(by: { $0.valueRise < $1.valueRise })
    
    guard mostRisingCryptoCurrency != nil else {
      mostRisingValueLabel.text = "N/A"
      return
    }
    mostRisingValueLabel.text = String(format: "%.1f", mostRisingCryptoCurrency!.valueRise)
  }
  
  @IBAction func switchPressed(_ sender: Any) {
    let theme: Theme = themeSwitch.isOn ? DarkTheme() : LightTheme()
    ThemeManager.shared.set(theme: theme)
  }
}

extension HomeViewController: Themeable {
  
  func registerForTheme() {
    NotificationCenter.default.addObserver(self, selector: #selector(themeChanged), name: Notification.Name.init("themeChanged"), object: nil)
  }
  
  func unregisterForTheme() {
    NotificationCenter.default.removeObserver(self)
  }
  
  @objc func themeChanged() {
    guard let theme = ThemeManager.shared.currentTheme else {
      return
    }
    
    let views = [view1, view2, view3, mostFallingView, mostRisingView]
    views.forEach { (view) in
      view?.backgroundColor = theme.widgetBackgroundColor
      view?.layer.borderColor = theme.borderColor.cgColor
    }
    
    let labels = [headingLabel, view1TextLabel, view2TextLabel, view3TextLabel, mostFallingHeadingLabel, mostFallingValueLabel, mostRisingHeadingLabel, mostRisingValueLabel]
    labels.forEach { (label) in
      label?.textColor = theme.textColor
    }
    
    view.backgroundColor = theme.backgroundColor
  }
  
}
