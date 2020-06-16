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
  @IBOutlet weak var view1TextLabel: UILabel!
  @IBOutlet weak var view2TextLabel: UILabel!
  @IBOutlet weak var view3TextLabel: UILabel!
  @IBOutlet weak var mostFallingHeadingLabel: UILabel!
  @IBOutlet weak var mostFallingImageView: UIImageView!
  @IBOutlet weak var mostFallingValueLabel: UILabel!
  @IBOutlet weak var mostRisingHeadingLabel: UILabel!
  @IBOutlet weak var mostRisingImageView: UIImageView!
  @IBOutlet weak var mostRisingValueLabel: UILabel!
  @IBOutlet weak var refreshButton: UIBarButtonItem!
  @IBOutlet weak var dataUpdatingActivityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var themeSwitch: CustomSwitch!
  
  var cryptoData: [CryptoCurrency]?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupThemeSwitch()
    setupLabels()
    updateCryptoData(self)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    registerForTheme()
    // Display LightTheme be default
    ThemeManager.shared.set(theme: LightTheme())
    registerForDataUpdated()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    unregisterForTheme()
    unregisterForDataUpdated()
  }
  
  func updateViewData() {
    setView1Data()
    setView2Data()
    setView3Data()
    setMostFallingData()
    setMostRisingData()
    dataUpdatingActivityIndicator.stopAnimating()
  }
  
  func setupLabels() {
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
    let increasedValueCryptoCurrencyNames = cryptoData?.filter {
      $0.currentValue > $0.previousValue
    }.reduce("") { (result, cryptoCurrency) in
      result == "" ? cryptoCurrency.name : result + ", " + cryptoCurrency.name
    }
    view2TextLabel.text = increasedValueCryptoCurrencyNames
  }
  
  func setView3Data() {
    let decreasedValueCryptoCurrencyNames = cryptoData?.filter {
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
    mostFallingHeadingLabel.text = String(mostFallingCryptoCurrency!.name)
    mostFallingImageView.downloadImage(url: mostFallingCryptoCurrency!.imageURLString)
    mostFallingValueLabel.text = mostFallingCryptoCurrency!.priceChange24h.asDollarString()
  }
  
  func setMostRisingData() {
    let mostRisingCryptoCurrency = cryptoData?.filter {
      $0.trend == .rising
    }.max(by: { $0.valueRise < $1.valueRise })
    
    guard mostRisingCryptoCurrency != nil else {
      mostRisingValueLabel.text = "N/A"
      return
    }
    mostRisingHeadingLabel.text = String(mostRisingCryptoCurrency!.name)
    mostRisingImageView.downloadImage(url: mostRisingCryptoCurrency!.imageURLString)
    mostRisingValueLabel.text = mostRisingCryptoCurrency!.priceChange24h.asDollarString()
  }
  
  @IBAction func updateCryptoData(_ sender: Any) {
    dataUpdatingActivityIndicator.startAnimating()
    DataGenerator.shared.updateData {
      self.cryptoData = DataGenerator.shared.cryptoCurrencies
    }
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
    NotificationCenter.default.removeObserver(self, name: Notification.Name.init("themeChanged"), object: nil)
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
    
    let labels = [view1TextLabel, view2TextLabel, view3TextLabel, mostFallingHeadingLabel, mostFallingValueLabel, mostRisingHeadingLabel, mostRisingValueLabel]
    labels.forEach { (label) in
      label?.textColor = theme.textColor
    }
    
    view.backgroundColor = theme.backgroundColor
    refreshButton.tintColor = theme.borderColor
    
    if let navigationBar = navigationController?.navigationBar {
      navigationBar.barTintColor = theme.navigationBarTintColor
      navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: theme.navigationBarTitleTextColor]
    }
  }
  
}

extension HomeViewController {
  
  func registerForDataUpdated() {
    NotificationCenter.default.addObserver(self, selector: #selector(dataUpdated), name: Notification.Name.init("dataUpdated"), object: nil)
  }
  
  func unregisterForDataUpdated() {
    NotificationCenter.default.removeObserver(self, name: Notification.Name.init("dataUpdated"), object: nil)
  }
  
  @objc func dataUpdated() {
    DispatchQueue.main.async {
      self.updateViewData()
    }
  }
  
}

extension HomeViewController {
  
  func setupThemeSwitch() {
    themeSwitch.onImage = #imageLiteral(resourceName: "DarkThemeSwitchBackground").cgImage
    themeSwitch.onTintColor = #colorLiteral(red: 0.01176470588, green: 0.2431372549, blue: 0.368627451, alpha: 1)
    themeSwitch.offImage = #imageLiteral(resourceName: "LightThemeSwitchBackground").cgImage
    themeSwitch.offBorderTintColor = #colorLiteral(red: 0.6156862745, green: 0.8549019608, blue: 0.9254901961, alpha: 1)
    themeSwitch.innerLayer.backgroundColor = #colorLiteral(red: 0.6156862745, green: 0.8549019608, blue: 0.9254901961, alpha: 1)
  }
  
}
