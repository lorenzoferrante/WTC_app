//
//  FieldViewController.swift
//  WTC
//
//  Created by Lorenzo Ferrante on 3/3/20.
//  Copyright © 2020 Lorenzo Ferrante. All rights reserved.
//

import UIKit

class FieldViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    static let fieldCell = "FieldCell"
    static let categoryCell = "CategoryCell"
    
    var fieldName: String?
    var fieldValue: String?
    
    private let categories = ["Champagne", "Vino Bianco", "Vino Rosso", "Bollicine"]
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpTableView()
        initFunctions()
    }

    private func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "FieldCell", bundle: nil), forCellReuseIdentifier: FieldViewController.fieldCell)
        tableView.register(UINib(nibName: "CategoryCell", bundle: nil), forCellReuseIdentifier: FieldViewController.categoryCell)
    }
    
    private func initFunctions() {
        setUpNavigationBar()
    }
    
    private func setUpNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(showAddView))
    }
    
    @objc private func showAddView() {
        if let rootVC = self.navigationController?.viewControllers[0] as? AddViewController {
            
            switch fieldName {
            case "Nome":
                if let val = fieldValue {
                    if let entry = rootVC.newEntry {
                        entry.name = val
                    } else {
                        rootVC.newEntry = EntryClass(name: val)
                    }
                }
            case "Categoria":
                if let val = fieldValue {
                    if let entry = rootVC.newEntry {
                        entry.category = val
                    } else {
                        rootVC.newEntry = EntryClass(category: val)
                    }
                }
            case "Descrizione":
                if let val = fieldValue {
                    if let entry = rootVC.newEntry {
                        entry.desc = val
                    } else {
                        rootVC.newEntry = EntryClass(desc: val)
                    }
                }
            case "Prezzo vendita":
                if let val = fieldValue {
                    if let entry = rootVC.newEntry {
                        entry.sell_price = Double(val)!
                    } else {
                        rootVC.newEntry = EntryClass(sell_price: Double(val)!)
                    }
                }
            case "Quantità":
                if let val = fieldValue {
                    if let entry = rootVC.newEntry {
                        entry.quantity = Int16(val)!
                    } else {
                        rootVC.newEntry = EntryClass(quantity: Int16(val)!)
                    }
                }
            case "Note":
                if let val = fieldValue {
                    if let entry = rootVC.newEntry {
                        entry.notes = val
                    } else {
                        rootVC.newEntry = EntryClass(notes: val)
                    }
                }
            case "Vendibile / Non":
                if fieldValue != nil {
                    if let entry = rootVC.newEntry {
                        entry.can_sell = true
                    } else {
                        rootVC.newEntry = EntryClass(can_sell: true)
                    }
                }
            default:
                return
            }
            
            if let rootTableView = rootVC.tableView {
                rootTableView.reloadData()
            }
        }
        self.navigationController?.popViewController(animated: true)
    }

}


// MARK: - UITableViewDataSource
extension FieldViewController {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.fieldName ?? ""
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let fieldName = fieldName {
            if fieldName == "Categoria" {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: FieldViewController.categoryCell, for: indexPath) as! CategoryCell
                cell.pickerView.delegate = self
                cell.pickerView.dataSource = self
                
                return cell
            }
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: FieldViewController.fieldCell, for: indexPath) as! FieldCell
        
        cell.textField.placeholder = "Inserisci \(fieldName ?? "campo")"
        cell.textField.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let fieldname = fieldName {
            if fieldname == "Categoria" {
                return 150.0
            }
        }
        
        return 50.0
    }
    
}


extension FieldViewController: UITextFieldDelegate {
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text {
            fieldValue = text
        }
    }
    
}


// MARK: - PickerView
extension FieldViewController {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
        
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        fieldValue = categories[row]
    }
    
}
