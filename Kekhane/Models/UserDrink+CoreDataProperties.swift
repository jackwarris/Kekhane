//
//  UserDrink+CoreDataProperties.swift
//  Kekhane
//
//  Created by Jack Warris on 17/06/2017.
//  Copyright © 2017 com.jackwarris. All rights reserved.
//

import Foundation
import CoreData


extension UserDrink {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserDrink> {
        return NSFetchRequest<UserDrink>(entityName: "UserDrink")
    }

    @NSManaged public var drinkType: String?
    @NSManaged public var toppings: String?
    @NSManaged public var price: Double
    @NSManaged public var customerOrder: CustomerOrder?

}
