//
//  DrinkModel.swift
//  Kekhane
//
//  Created by Jack Warris on 17/06/2017.
//  Copyright © 2017 com.jackwarris. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct OrderItem {
    
    let key: String
    let name: String
    let dbRef: DatabaseReference?
    
    init(name: String, key: String = "") {
        self.key = key
        self.name = name
        self.dbRef = nil
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        key = snapshot.key
        name = snapshotValue["name"] as! String
        dbRef = snapshot.ref
    }
    
}
