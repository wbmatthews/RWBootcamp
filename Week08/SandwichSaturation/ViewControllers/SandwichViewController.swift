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
  let searchController = UISearchController(searchResultsController: nil)
//  var sandwiches = [SandwichData]()
//  var filteredSandwiches = [SandwichData]()
  
  private let appDelegate = UIApplication.shared.delegate as! AppDelegate
  private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  private var fetchedSandwichesRC: NSFetchedResultsController<Sandwich>!
  private var filterForSauceAmount: SauceAmount!

//  required init?(coder: NSCoder) {
//    super.init(coder: coder)
//
//  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let previouslyRun = UserDefaults.standard.object(forKey: "previouslyRun") as? Bool, previouslyRun {
      print("No data init needed")
    } else {
      let defaultSandwiches = loadSandwiches()
      for sandwich in defaultSandwiches {
        saveSandwich(sandwich)
      }
      UserDefaults.standard.set(true, forKey: "previouslyRun")
    }
        
    let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(presentAddView(_:)))
    navigationItem.rightBarButtonItem = addButton
    
    // Setup Search Controller
    
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = "Filter Sandwiches"
    navigationItem.searchController = searchController
    definesPresentationContext = true
    searchController.searchBar.scopeButtonTitles = SauceAmount.allCases.map { $0.rawValue }
    
    // MARK: A1: Loading the UserDefaults for the searchBar scopeButton
    let scopeButtonIndex = UserDefaults.standard.object(forKey: "scopeButtonIndex") as? Int ?? 0
    searchController.searchBar.selectedScopeButtonIndex = scopeButtonIndex
    
    searchController.searchBar.delegate = self
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    refresh()
  }
  
  func loadSandwiches() -> [SandwichData] {
    
    //MARK: A2: Loading the sandwich data from the JSON file
    guard let sandwichJSONURL = Bundle.main.url(forResource: "sandwiches", withExtension: "json") else { return [] }
    let decoder  = JSONDecoder()
    
    do {
      
      let sandwichJSONData = try Data(contentsOf: sandwichJSONURL)
      let sandwiches = try decoder.decode([SandwichData].self, from: sandwichJSONData)
      return sandwiches
      
    } catch let error as NSError {
      print("Unable to load data. \(error), \(error.userInfo)")
      return []
    }
  }
  
  private func refresh(withFilterText query: String? = nil, sauceAmount: SauceAmount? = nil) {
    let request = Sandwich.fetchRequest() as NSFetchRequest<Sandwich>
         if isFiltering {
          if sauceAmount == SauceAmount.any {
            request.predicate = NSPredicate(format: "name CONTAINS[cd] %@", query!)
          } else {
            request.predicate = NSPredicate(format: "name CONTAINS[cd] %@ AND sauceFactor = %@", query!, sauceAmount!.rawValue)
          }
         }
    let nameSort = NSSortDescriptor(key: #keyPath(Sandwich.name), ascending: true, selector: #selector(NSString.caseInsensitiveCompare))
    request.sortDescriptors = [nameSort]
    
    do {
      fetchedSandwichesRC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
      try fetchedSandwichesRC.performFetch()
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
    
  }

  func saveSandwich(_ sandwich: SandwichData) {
//    sandwiches.append(sandwich)
    
    let newSandwich = Sandwich(entity: Sandwich.entity(), insertInto: context)
    newSandwich.name = sandwich.name
    newSandwich.imageName = sandwich.imageName
    
    let sauceFactor = Sauciness(entity: Sauciness.entity(), insertInto: context)
    sauceFactor.sauceAmount = sandwich.sauceAmount
    newSandwich.sauceFactor = sauceFactor
    
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
  
//  func filterContentForSearchText(_ searchText: String, sauceAmount: SauceAmount? = nil) {
//    filteredSandwiches = sandwiches.filter { (sandwhich: SandwichData) -> Bool in
//      let doesSauceAmountMatch = sauceAmount == .any || sandwhich.sauceAmount == sauceAmount
//
//      if isSearchBarEmpty {
//        return doesSauceAmountMatch
//      } else {
//        return doesSauceAmountMatch && sandwhich.name.lowercased()
//          .contains(searchText.lowercased())
//      }
//    }
//
//    tableView.reloadData()
//  }
  
  var isFiltering: Bool {
    let searchBarScopeIsFiltering =
      searchController.searchBar.selectedScopeButtonIndex != 0
    return searchController.isActive &&
      (!isSearchBarEmpty || searchBarScopeIsFiltering)
  }
  
  // MARK: - Table View
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return fetchedSandwichesRC.fetchedObjects?.count ?? 0
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "sandwichCell", for: indexPath) as? SandwichCell
      else { return UITableViewCell() }
    
//    let sandwich = isFiltering ?
//      filteredSandwiches[indexPath.row] :
//      sandwiches[indexPath.row]
    
    let sandwich = fetchedSandwichesRC.object(at: indexPath)

    cell.thumbnail.image = UIImage.init(imageLiteralResourceName: sandwich.imageName)
    cell.nameLabel.text = sandwich.name
    cell.sauceLabel.text = sandwich.sauceFactor.sauceFactor

    return cell
  }
}

// MARK: - UISearchResultsUpdating
extension SandwichViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    let searchBar = searchController.searchBar
    let sauceAmount = SauceAmount(rawValue:
      searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex])

//    filterContentForSearchText(searchBar.text!, sauceAmount: sauceAmount)
    refresh(withFilterText: searchBar.text!, sauceAmount: sauceAmount)
    tableView.reloadData()
  }
}

// MARK: - UISearchBarDelegate
extension SandwichViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar,
      selectedScopeButtonIndexDidChange selectedScope: Int) {
    
    //MARK: A1: Saving the scope button index to UserDefaults
    UserDefaults.standard.set(selectedScope, forKey: "scopeButtonIndex")
    
    let sauceAmount = SauceAmount(rawValue:
      searchBar.scopeButtonTitles![selectedScope])
//    filterContentForSearchText(searchBar.text!, sauceAmount: sauceAmount)
    refresh(withFilterText: searchBar.text!, sauceAmount: sauceAmount)
    tableView.reloadData()
  }
}

