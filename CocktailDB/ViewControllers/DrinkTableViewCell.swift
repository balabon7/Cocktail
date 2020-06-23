//
//  DrinkTableViewCell.swift
//  CocktailDB
//
//  Created by mac on 23.06.2020.
//  Copyright © 2020 Aleksandr Balabon. All rights reserved.
//

import UIKit

class DrinkTableViewCell: UITableViewCell {
    
    @IBOutlet weak var drinkImageView: UIImageView!
    
    @IBOutlet weak var drinkLabel: UILabel!
    
    func setupDrinkLabel(){
        
       drinkLabel.textColor = #colorLiteral(red: 0.4941176471, green: 0.4941176471, blue: 0.4941176471, alpha: 1)
       drinkLabel.font = UIFont(name: "Roboto-Regular", size: 16)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        drinkImageView.image = nil
        drinkLabel.text = nil
    }

}
