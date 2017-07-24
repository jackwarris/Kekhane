//
//  DrinkModel.swift
//  Kekhane
//
//  Created by Jack Warris on 17/06/2017.
//  Copyright © 2017 com.jackwarris. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct DrinkItem {
    
    let name: String
    let price: Double
    
    init(name: String, price: Double) {
        self.name = name
        self.price = price
    }
    
    init(snapshot: DataSnapshot) {
//        print(snapshot.value as Any)
        let snapshot = snapshot.value as! [String: AnyObject]
        
        name = snapshot["Name"] as! String
        price = snapshot["Price"] as! Double
    }
    
}
