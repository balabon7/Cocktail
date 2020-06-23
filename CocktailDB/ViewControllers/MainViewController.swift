//
//  ViewController.swift
//  CocktailDB
//
//  Created by mac on 22.06.2020.
//  Copyright © 2020 Aleksandr Balabon. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class MainViewController: UIViewController, DataFilterDelegate {
    
    private var strDrinks: [Drinks] = []
    private var categories: [String] = []
    private var filteredCategories = [String]()
    
    let networkingClient = NetworkingClient()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if filteredCategories.isEmpty {
            getAllDrinks()
        } else {
            getFilteredDrinks(categories: filteredCategories)
        }
    }
    
    private func setupNavBar() {
        
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
        }
        
        title = "Drinks"
          self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Roboto-Regular", size: 16.0)!, NSAttributedString.Key.foregroundColor: UIColor.black]
        
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.tintColor = UIColor.black
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
    }
    
    
    private func getAllDrinks() {
        networkingClient.getList() { data in
            
            self.categories.removeAll()
            guard let data = data else {return}
            let json = JSON(data)
            
            for object in json["drinks"] {
                let strCategory = object.1["strCategory"].stringValue
                self.categories.append(strCategory)
            }

            self.getFilteredDrinks(categories: self.categories)
        }
    }
    
    
    func updateInfromation(filterArray: [String]) {
        filteredCategories = filterArray
        print("filteredCategoriesArray update", filteredCategories)
       
    }
    
    private func getFilteredDrinks(categories: [String]){
        
        for category in categories {

            networkingClient.getCategory(category: category) {  [weak self] (data) in
                guard let data = data else {return}
                let json = JSON(data)
                
                let objects = json["drinks"]
                
                self?.strDrinks.removeAll()
                
                for object in objects {
                    let idDrink = object.1["idDrink"].intValue
                    let strDrink = object.1["strDrink"].stringValue
                    let strDrinkThumb = object.1["strDrinkThumb"].stringValue
                    
                    self?.strDrinks.append(Drinks(idDrink: idDrink, strDrink: strDrink, strDrinkThumb: strDrinkThumb))
                }
                self?.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let filterVC = segue.destination as? FiltersViewController else { return }
        filterVC.delegate = self
    }
}


extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.white
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.black
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if filteredCategories.isEmpty {
             return categories.count
         } else {
            return filteredCategories.count
         }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if filteredCategories.isEmpty {
                return categories[section]
            } else {
               return filteredCategories[section]
            }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return strDrinks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DrinkTableViewCell
        
        cell.drinkLabel?.text = strDrinks[indexPath.row].strDrink
        cell.setupDrinkLabel()
        cell.textLabel?.textColor = UIColor.gray
        
        guard let url = URL(string: strDrinks[indexPath.row].strDrinkThumb) else { return cell }

        cell.drinkImageView?.sd_setImage(with: url, placeholderImage: UIImage(named: "drink"))
        
        
        return cell
    }
}
