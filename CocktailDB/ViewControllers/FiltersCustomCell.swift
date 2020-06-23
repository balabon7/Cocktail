//
//  CustomCell.swift
//  CocktailDB
//
//  Created by mac on 22.06.2020.
//  Copyright © 2020 Aleksandr Balabon. All rights reserved.
//

import UIKit

class FiltersCustomCell: UITableViewCell {
    
   func setupTextLabel() {
    textLabel?.textColor = #colorLiteral(red: 0.4941176471, green: 0.4941176471, blue: 0.4941176471, alpha: 1)
    textLabel?.font = UIFont(name: "Roboto-Regular", size: 16)
    }
    
    override func prepareForReuse() {
        super .prepareForReuse()
        accessoryType = .checkmark
        textLabel?.text = nil
    }

}
