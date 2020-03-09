//
//  ViewController.swift
//  WTC
//
//  Created by Lorenzo Ferrante on 3/2/20.
//  Copyright © 2020 Lorenzo Ferrante. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    static let summaryEntryCell = "EntrySummaryCell"
    
    private var selectedEntryIndex: Int = 0
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var entries: [Entry] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    private var filteredEntries: [Entry] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    private var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    private var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "WTC"
        initFunctions()
    }
    
    private func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "EntrySummaryCell", bundle: nil), forCellReuseIdentifier: ViewController.summaryEntryCell)
        tableView.contentInset.top = 20.0
    }
    
    private func setUpSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Ricerca prodotti"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func initFunctions() {
        //addInitialData()
        setUpTableView()
        setUpSearchController()
        setUpNotifications()
        setUpNavigationBar()
        retrievaData()
    }
    
    private func setUpNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(updataDataInTableView), name: .needDataUpdate, object: nil)
    }
    
    private func setUpNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showAddView))
    }
    
    @objc private func showAddView() {
        self.performSegue(withIdentifier: "ShowAdd", sender: self)
    }

}

// MARK: - UITableViewDataSource
extension ViewController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    	if (entries.count == 0) {
    		return 1
        } else if isFiltering {
            return filteredEntries.count
        }
        return entries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    	if (entries.count == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    		
    		cell.textLabel!.text = "Nessun Dato. Aggiungi Qualcosa!"    
    		
    		return cell
    	}
    	
        let cell = tableView.dequeueReusableCell(withIdentifier: ViewController.summaryEntryCell, for: indexPath) as! EntrySummaryCell
        
        var selectedDataSource: [Entry] = entries
        
        if isFiltering {
            selectedDataSource = filteredEntries
        }
        
        cell.name.text = selectedDataSource[indexPath.row].name!
        cell.desc.text = selectedDataSource[indexPath.row].category!
        cell.quantity.text = "Quantità: \(selectedDataSource[indexPath.row].quantity)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedEntryIndex = indexPath.row
        self.performSegue(withIdentifier: "ShowDetail", sender: self)
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
}


// MARK: - Navigation
extension ViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            guard let detailNavigationController = segue.destination as? UINavigationController else { return }
            guard let detailVC = detailNavigationController.viewControllers[0] as? DetailViewController else { return }
            /*guard let result = retrievaDataWithIndex(index: selectedEntryIndex) else {
                print("[ERROR] Retrieving item to pass to Detail")
                return
            }*/
            if isFiltering {
                detailVC.entry = filteredEntries[selectedEntryIndex]
            } else {
                detailVC.entry = entries[selectedEntryIndex]
            }
        }
    }
    
}


// MARK: - CoreData
extension ViewController {
    
    @objc private func updataDataInTableView() {
        retrievaData()
    }
    
    private func retrievaData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Entry")
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            guard let resultEntries = result as? [Entry] else {
                print("[ERROR] Could not convert fetched data into Entry")
                return
            }
            self.entries = resultEntries
            
        } catch let error as NSError {
            print("[ERROR] Could not fetch: \(error.localizedDescription)")
        }
    }
    
    private func retrievaDataWithIndex(index: Int) -> Entry? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Entry")
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            guard let resultEntries = result as? [Entry] else {
                print("[ERROR] Could not convert fetched data into Entry")
                return nil
            }
            return resultEntries[index]
        } catch let error as NSError {
            print("[ERROR] Could not fetch: \(error.localizedDescription)")
        }
        
        return nil
    }
    
    private func addInitialData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entriesEntity = NSEntityDescription.entity(forEntityName: "Entry", in: managedContext)
        
        let entry = NSManagedObject(entity: entriesEntity!, insertInto: managedContext)
        
        entry.setValue(true, forKey: "can_sell")
        entry.setValue("Champagne", forKey: "category")
        entry.setValue("Annata 2008", forKey: "desc")
        entry.setValue("Cristal-Roederer", forKey: "name")
        entry.setValue("", forKey: "notes")
        entry.setValue(4, forKey: "quantity")
        entry.setValue(185.00, forKey: "sell_price")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("[ERROR] Could not save: \(error.localizedDescription)")
        }

    }
    
}


extension ViewController: UISearchResultsUpdating {
    
    private func filterContentForSearchText(_ searchText: String, category: String? = nil) {
        filteredEntries = entries.filter { (entry: Entry) -> Bool in
            if let name = entry.name {
                return name.lowercased().contains(searchText)
            }
            return false
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
    
}


