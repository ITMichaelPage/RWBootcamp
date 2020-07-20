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
  var sandwiches = [Sandwich]()
  var filteredSandwiches = [Sandwich]()

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    let coreDataJSONImportComplete = defaults.bool(forKey: "CoreDataJSONImportComplete")
    if !coreDataJSONImportComplete {
      saveSeedDataToCoreData()
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
  
  func loadSeedDataFromJSON() -> [SandwichData] {
    let sandwichesJSONURL = URL(fileURLWithPath: "sandwiches", relativeTo: Bundle.main.bundleURL).appendingPathExtension("json")

    guard FileManager.default.fileExists(atPath: sandwichesJSONURL.path) else {
      fatalError("Unable to read \(sandwichesJSONURL.path)")
    }
    
    let decoder = JSONDecoder()
    
    do {
      let sandwichesData = try Data(contentsOf: sandwichesJSONURL)
      let seedData = try decoder.decode([SandwichData].self, from: sandwichesData)
      return seedData
    } catch let error {
      fatalError(error.localizedDescription)
    }
  }

  func saveSeedDataToCoreData() {
    let seedData = loadSeedDataFromJSON()
    seedData.forEach { (sandwichData) in
      saveSandwich(sandwichData)
    }
  }

  func saveSandwich(_ sandwichData: SandwichData) {
    let sauceAmountModel = SauceAmountModel(entity: SauceAmountModel.entity(), insertInto: context)
    sauceAmountModel.sauceAmount = sandwichData.sauceAmount

    let sandwich = Sandwich(entity: Sandwich.entity(), insertInto: context)
    sandwich.name = sandwichData.name
    sandwich.sauceAmountModel = sauceAmountModel
    sandwich.imageName = sandwichData.imageName

    appDelegate.saveContext()
    refresh()
  }

  @objc
  func presentAddView(_ sender: Any) {
    performSegue(withIdentifier: "AddSandwichSegue", sender: self)
  }
  
  // MARK: - Search Controller
  var isSearchBarEmpty: Bool {
    return searchController.searchBar.text?.isEmpty ?? true
  }
  
  private func filterSandwiches(searchText: String? = nil, sauceAmount: SauceAmount? = nil) {
    let request = Sandwich.fetchRequest() as NSFetchRequest<Sandwich>
    
    let nameSort = NSSortDescriptor(key: #keyPath(Sandwich.name), ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)))
    request.sortDescriptors = [nameSort]
    
    var predicates: [NSPredicate] = []
    
    if let trimmedSearchText = searchText?.trimmingCharacters(in: .whitespacesAndNewlines), !trimmedSearchText.isEmpty {
      let searchTextPredicate = NSPredicate(format: "name CONTAINS[cd] %@", trimmedSearchText)
      predicates.append(searchTextPredicate)
    }
    
    if let sauceAmount = sauceAmount, sauceAmount != SauceAmount.any {
      let sauceAmountPredicate = NSPredicate(format: "sauceAmountModel.sauceAmountString MATCHES %@", sauceAmount.rawValue)
      predicates.append(sauceAmountPredicate)
    }
    
    request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    
    do {
      fetchedRC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
      try fetchedRC.performFetch()
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
    
    tableView.reloadData()
  }
  
  private func refresh() {
    // This call with no arguments displays all sandwiches
    filterSandwiches()
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
    cell.sauceLabel.text = sandwich.sauceAmountModel.sauceAmount.description

    return cell
  }
}

// MARK: - UISearchResultsUpdating
extension SandwichViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    let searchBar = searchController.searchBar
    let sauceAmount = SauceAmount(rawValue:
      searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex])

    filterSandwiches(searchText: searchBar.text!, sauceAmount: sauceAmount)
  }
}

// MARK: - UISearchBarDelegate
extension SandwichViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar,
      selectedScopeButtonIndexDidChange selectedScope: Int) {
    let sauceAmount = SauceAmount(rawValue:
      searchBar.scopeButtonTitles![selectedScope])
    filterSandwiches(searchText: searchBar.text!, sauceAmount: sauceAmount)
    defaults.set(selectedScope, forKey: "SearchBarSelectedScopeButtonIndex")
  }
}
