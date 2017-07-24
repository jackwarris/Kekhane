//
//  DrinkOrderCell.swift
//  Kekhane
//
//  Created by Jack Warris on 17/06/2017.
//  Copyright © 2017 com.jackwarris. All rights reserved.
//

import UIKit

class DrinkOrderCell: UITableViewCell {

    @IBOutlet weak var customerDrinkName: UITextField!
    @IBOutlet weak var customerDrinkToppings: UITextField!
    @IBOutlet weak var customerDrinkPrice: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
