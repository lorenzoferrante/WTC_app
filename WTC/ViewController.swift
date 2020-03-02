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
    
    var entries: [Entry] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    // Prova commit
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "WTC Database"
        
        setUpTableView()
        initFunctions()
    }
    
    private func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "EntrySummaryCell", bundle: nil), forCellReuseIdentifier: ViewController.summaryEntryCell)
    }
    
    private func initFunctions() {
        //addInitialData()
        retrievaData()
    }

}

// MARK: - UITableViewDataSource
extension ViewController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ViewController.summaryEntryCell, for: indexPath) as! EntrySummaryCell
        
        cell.name.text = entries[indexPath.row].name!
        cell.desc.text = entries[indexPath.row].desc!
        cell.quantity.text = "Quantità: \(entries[indexPath.row].quantity)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
}


// MARK: - CoreData
extension ViewController {
    
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


