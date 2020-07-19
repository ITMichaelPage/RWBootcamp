//
//  SandwichViewController.swift
//  SandwichSaturation
//
//  Created by Jeff Rames on 7/3/20.
//  Copyright © 2020 Jeff Rames. All rights reserved.
//

import UIKit
import CoreData

protocol SandwichDataSource {
  func saveSandwich(_: SandwichData)
}

class SandwichViewController: UITableViewController, SandwichDataSource {
  private let appDelegate = UIApplication.shared.delegate as! AppDelegate
  private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  let defaults = UserDefaults.standard
  let searchController = UISearchController(searchResultsController: nil)
  private var fetchedRC: NSFetchedResultsController<Sandwich>!
  var sandwiches = [SandwichData]()
  var filteredSandwiches = [SandwichData]()

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    let coreDataJSONImportComplete = defaults.bool(forKey: "CoreDataJSONImportComplete")
    if !coreDataJSONImportComplete {
      loadSandwichesFromJSON()
      saveSandwichesToCoreData()
      defaults.set(true, forKey: "CoreDataJSONImportComplete")
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
        
    let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(presentAddView(_:)))
    navigationItem.rightBarButtonItem = addButton
    
    // Setup Search Controller
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = "Filter Sandwiches"
    navigationItem.searchController = searchController
    definesPresentationContext = true
    searchController.searchBar.scopeButtonTitles = SauceAmount.allCases.map { $0.rawValue }
    searchController.searchBar.delegate = self
    searchController.searchBar.selectedScopeButtonIndex = defaults.integer(forKey: "SearchBarSelectedScopeButtonIndex")
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    refresh()
  }
  
  func loadSandwichesFromJSON() {
    let sandwichesJSONURL = URL(fileURLWithPath: "sandwiches", relativeTo: Bundle.main.bundleURL).appendingPathExtension("json")

    guard FileManager.default.fileExists(atPath: sandwichesJSONURL.path) else {
      return
    }
    
    let decoder = JSONDecoder()
    
    do {
      let sandwichesData = try Data(contentsOf: sandwichesJSONURL)
      sandwiches = try decoder.decode([SandwichData].self, from: sandwichesData)
    } catch let error {
      print(error)
    }
  }

  func saveSandwichesToCoreData() {
    sandwiches.forEach { (sandwichData) in
      saveSandwich(sandwichData)
    }
  }

  func saveSandwich(_ sandwichData: SandwichData) {
    let sauceAmountModel = SauceAmountModel(entity: SauceAmountModel.entity(), insertInto: context)
    sauceAmountModel.sauceAmount = sandwichData.sauceAmount

    let sandwich = Sandwich(entity: Sandwich.entity(), insertInto: context)
    sandwich.name = sandwichData.name
    sandwich.sauceAmount = sauceAmountModel
    sandwich.imageName = sandwichData.imageName

    appDelegate.saveContext()
    refresh()
    tableView.reloadData()
  }

  @objc
  func presentAddView(_ sender: Any) {
    performSegue(withIdentifier: "AddSandwichSegue", sender: self)
  }
  
  // MARK: - Search Controller
  var isSearchBarEmpty: Bool {
    return searchController.searchBar.text?.isEmpty ?? true
  }
  
  func filterContentForSearchText(_ searchText: String,
                                  sauceAmount: SauceAmount? = nil) {
    filteredSandwiches = sandwiches.filter { (sandwich: SandwichData) -> Bool in
      let doesSauceAmountMatch = sauceAmount == .any || sandwich.sauceAmount == sauceAmount

      if isSearchBarEmpty {
        return doesSauceAmountMatch
      } else {
        return doesSauceAmountMatch && sandwich.name.lowercased()
          .contains(searchText.lowercased())
      }
    }
    
    tableView.reloadData()
  }
  
  var isFiltering: Bool {
    let searchBarScopeIsFiltering =
      searchController.searchBar.selectedScopeButtonIndex != 0
    return searchController.isActive &&
      (!isSearchBarEmpty || searchBarScopeIsFiltering)
  }
  
  private func refresh() {
    let request = Sandwich.fetchRequest() as NSFetchRequest<Sandwich>
    let nameSort = NSSortDescriptor(key: #keyPath(Sandwich.name), ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)))
    request.sortDescriptors = [nameSort]
    do {
      fetchedRC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
      try fetchedRC.performFetch()
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
  }
  
  // MARK: - Table View
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let sections = fetchedRC.sections, let objects = sections[section].objects else {
      return 0
    }
    return objects.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "sandwichCell", for: indexPath) as? SandwichCell else {
      return UITableViewCell()
    }
    
    let sandwich = fetchedRC.object(at: indexPath)

    cell.thumbnail.image = UIImage.init(imageLiteralResourceName: sandwich.imageName)
    cell.nameLabel.text = sandwich.name
    cell.sauceLabel.text = sandwich.sauceAmount.sauceAmount.description

    return cell
  }
}

// MARK: - UISearchResultsUpdating
extension SandwichViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    let searchBar = searchController.searchBar
    let sauceAmount = SauceAmount(rawValue:
      searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex])

    filterContentForSearchText(searchBar.text!, sauceAmount: sauceAmount)
  }
}

// MARK: - UISearchBarDelegate
extension SandwichViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar,
      selectedScopeButtonIndexDidChange selectedScope: Int) {
    let sauceAmount = SauceAmount(rawValue:
      searchBar.scopeButtonTitles![selectedScope])
    filterContentForSearchText(searchBar.text!, sauceAmount: sauceAmount)
    defaults.set(selectedScope, forKey: "SearchBarSelectedScopeButtonIndex")
  }
}

