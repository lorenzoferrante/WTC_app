//
//  DetailViewController.swift
//  WTC
//
//  Created by Lorenzo Ferrante on 3/2/20.
//  Copyright © 2020 Lorenzo Ferrante. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    static let detailCell = "DetailCell"
    
    var entry: Entry? {
        didSet {
            if let tableView = tableView {
                tableView.reloadData()
            }
        }
    }
    
    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view.
            self.title = "Dettaglio Prodotto"
            
            setUpTableView()
            initFunctions()
        }
        
        private func setUpTableView() {
            tableView.delegate = self
            tableView.dataSource = self
        }
        
        private func initFunctions() {
            //addInitialData()
            if entry != nil {
                tableView.reloadData()
            }
        }

}

// MARK: - UITableViewDataSource
extension DetailViewController {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailViewController.detailCell, for: indexPath)
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = entry?.name
            cell.textLabel?.font = UIFont.systemFont(ofSize: 22.0, weight: .bold)
        case 1:
            cell.textLabel?.text = "Categoria: \(entry?.category ?? "")"
        case 2:
            cell.textLabel?.text = "Desc: \(entry?.desc ?? "")"
        case 3:
            cell.textLabel?.text = "Prezzo vendita: \(entry?.sell_price ?? 0)€"
        case 4:
            cell.textLabel?.text = "Quantità: \(entry?.quantity ?? 0) disponibili"
        case 5:
            cell.textLabel?.text = "Note: \(entry?.notes ?? "nessuna nota")"
        case 6:
            cell.textLabel?.text = "Vendibile"
        default:
            cell.textLabel?.text = "Error fetching data..."
        }
        
        return cell
    }
        
}

