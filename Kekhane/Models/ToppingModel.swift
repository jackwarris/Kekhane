//
//  DrinkModel.swift
//  Kekhane
//
//  Created by Jack Warris on 17/06/2017.
//  Copyright © 2017 com.jackwarris. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct ToppingItem {
    
    let name: String
    let price: Double
    let limit: String
    
    init(name: String, price: Double, limit: String) {
        self.name = name
        self.price = price
        self.limit = limit
    }
    
    init(snapshot: DataSnapshot) {
//        print(snapshot.value as Any)
        let snapshot = snapshot.value as! [String: AnyObject]
        
        name = snapshot["Name"] as! String
        price = snapshot["Price"] as! Double
        limit = snapshot["Limit"] as! String
    }
    
}
