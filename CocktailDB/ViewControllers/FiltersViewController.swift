//
//  FiltersViewController.swift
//  CocktailDB
//
//  Created by mac on 22.06.2020.
//  Copyright © 2020 Aleksandr Balabon. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol DataFilterDelegate: class {
    func updateInfromation(filterArray: [String])
}

class FiltersViewController: UIViewController {
    
    @IBOutlet weak var applyButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: DataFilterDelegate?
    
    private var categoriesArray = [String]()
    private var isFilteringArray = [Bool](repeating: true, count: 11)
    private var selectedFilters = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        setupNavigationBar()
        applyButton.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 16)
    }
    
    private func setupNavigationBar() {
        title = "Filters"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Roboto-Regular", size: 16.0)!, NSAttributedString.Key.foregroundColor: UIColor.black]
        
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.tintColor = UIColor.black
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getFiltersList()
    }
    
    
    @IBAction func applyPressed(_ sender: UIButton) {
        
        delegate?.updateInfromation(filterArray: selectedFilters)
        navigationController?.popViewController(animated: true)
        print("apply", selectedFilters)
    }
    
    private func getFiltersList() {
        
        let networkingClient = NetworkingClient()
        networkingClient.getList() { data in
            
            self.categoriesArray.removeAll()
            
            guard let data = data else {return}
            let json = JSON(data)
            let objects = json["drinks"]
            for object in objects {
                
                let strCategory = object.1["strCategory"].stringValue
                self.categoriesArray.append(strCategory)
                self.selectedFilters = self.categoriesArray
            }
            self.tableView.reloadData()
        }
    }
}

extension FiltersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        func appendOrRemoveToggle() {
            let cell = tableView.cellForRow(at: indexPath) as! FiltersCustomCell
            guard let category = cell.textLabel!.text else { return }
            if selectedFilters.contains(category) {
                if let index = selectedFilters.firstIndex(of: category) {
                    selectedFilters.remove(at: index)
                }
            } else {
                selectedFilters.append(category)
            }
        }
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            self.isFilteringArray[indexPath.row] = false
            appendOrRemoveToggle()
        } else  {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            appendOrRemoveToggle()
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 81
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "filter", for: indexPath) as! FiltersCustomCell
        
        cell.tintColor = UIColor.black
        cell.textLabel?.text = categoriesArray[indexPath.row]
        cell.setupTextLabel()
        
        if self.isFilteringArray[indexPath.row] {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType  = .none
        }
        
        return cell
    }
    
}
