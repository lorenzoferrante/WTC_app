//
//  AddViewController.swift
//  WTC
//
//  Created by Lorenzo Ferrante on 3/3/20.
//  Copyright © 2020 Lorenzo Ferrante. All rights reserved.
//

import UIKit
import CoreData

class AddViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    static let insertCell = "InsertCell"
    
    var selectedIndexRow: Int = 0
    var newEntry: EntryClass? {
        didSet {
            tableView.reloadData()
        }
    }
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Aggiungi Prodotto"

        setUpTableView()
        initFunctions()
    }
    
    private func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "InsertCell", bundle: nil), forCellReuseIdentifier: AddViewController.insertCell)
    }
    
    private func initFunctions() {
        //addInitialData()
        setUpNavigationBar()
    }
    
    private func setUpNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(showAddView))
    }
    
    @objc private func showAddView() {
        if checkIfEntryIsNotEmpty() {
            if let entry = newEntry {
                saveCoreData(newEntry: entry)
            } else {
                let incompleteDataAlert = UIAlertController(title: "Errore", message: "Contattare Lorenzo per questo errore", preferredStyle: .alert)
                incompleteDataAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                    self.navigationController?.popViewController(animated: true)
                }))
                self.navigationController?.present(incompleteDataAlert, animated: true, completion: nil)
            }
            
            self.navigationController?.dismiss(animated: true, completion: nil)
        } else {
            let incompleteDataAlert = UIAlertController(title: "Errore", message: "Inserisci tutti i dati richiesti", preferredStyle: .alert)
            incompleteDataAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                self.navigationController?.popViewController(animated: true)
            }))
            self.navigationController?.present(incompleteDataAlert, animated: true, completion: nil)
        }
    }

}

// MARK: - UITableViewDataSource
extension AddViewController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AddViewController.insertCell, for: indexPath) as! InsertCell

        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Nome"
            cell.detailTextLabel?.text = newEntry?.name ?? ""
        case 1:
            cell.textLabel?.text = "Categoria"
            cell.detailTextLabel?.text = newEntry?.category ?? ""
        case 2:
            cell.textLabel?.text = "Descrizione"
            cell.detailTextLabel?.text = newEntry?.desc ?? ""
        case 3:
            cell.textLabel?.text = "Prezzo vendita"
            cell.detailTextLabel?.text = "\(newEntry?.sell_price ?? 0)€"
        case 4:
            cell.textLabel?.text = "Quantità"
            cell.detailTextLabel?.text = "\(newEntry?.quantity ?? 0)"
        case 5:
            cell.textLabel?.text = "Note"
            cell.detailTextLabel?.text = newEntry?.notes ?? ""
        case 6:
            cell.textLabel?.text = "Vendibile / Non"
            cell.detailTextLabel?.text = "\(newEntry?.can_sell ?? true)"
        default:
            cell.textLabel?.text = "Error fetching data..."
            cell.detailTextLabel?.text = ""
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndexRow = indexPath.row
        self.performSegue(withIdentifier: "EditField", sender: self)
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
}


// MARK: - Navigation
extension AddViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditField" {
            guard let destVC = segue.destination as? FieldViewController else { return }
            
            switch selectedIndexRow {
            case 0:
                destVC.fieldName = "Nome"
            case 1:
                destVC.fieldName = "Categoria"
            case 2:
                destVC.fieldName = "Descrizione"
            case 3:
                destVC.fieldName = "Prezzo vendita"
            case 4:
                destVC.fieldName = "Quantità"
            case 5:
                destVC.fieldName = "Note"
            case 6:
                destVC.fieldName = "Vendibile / Non"
            default:
                destVC.fieldName = ""
            }
        }
    }
    
}


// MARK: - CoreData
extension AddViewController {
    
    private func checkIfEntryIsNotEmpty() -> Bool {
        guard let entry = newEntry else { return false }
        
        guard (entry.name != nil) else { return false }
        guard (entry.desc != nil) else { return false }
        guard (entry.can_sell != nil) else { return false }
        guard (entry.sell_price != nil) else { return false }
        guard (entry.quantity != nil) else { return false }
        guard (entry.notes != nil) else { return false }
        guard (entry.category != nil) else { return false }
        
        return true
    }
    
    @objc private func saveCoreData(newEntry: EntryClass) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entriesEntity = NSEntityDescription.entity(forEntityName: "Entry", in: managedContext)
        
        let entry = NSManagedObject(entity: entriesEntity!, insertInto: managedContext)
        
        entry.setValue(true, forKey: "can_sell")
        entry.setValue(newEntry.category, forKey: "category")
        entry.setValue(newEntry.desc, forKey: "desc")
        entry.setValue(newEntry.name, forKey: "name")
        entry.setValue(newEntry.notes, forKey: "notes")
        entry.setValue(newEntry.quantity, forKey: "quantity")
        entry.setValue(newEntry.quantity, forKey: "sell_price")
        
        do {
            try managedContext.save()
            NotificationCenter.default.post(name: .needDataUpdate, object: nil)
        } catch let error as NSError {
            DispatchQueue.main.async {
                let incompleteDataAlert = UIAlertController(title: "Errore",
                                                            message: "Non sono riuscito a salvare i dati!",
                                                            preferredStyle: .alert)
                incompleteDataAlert.addAction(UIAlertAction(title: "Ok",
                                                            style: .default,
                                                            handler: { (action) in
                    self.navigationController?.popViewController(animated: true)
                }))
                self.navigationController?.present(incompleteDataAlert, animated: true, completion: nil)
            }
            print("[ERROR] Could not save: \(error.localizedDescription)")
        }
    }
    
}
