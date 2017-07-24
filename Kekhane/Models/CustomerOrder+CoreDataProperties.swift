//
//  CustomerOrder+CoreDataProperties.swift
//  Kekhane
//
//  Created by Jack Warris on 17/06/2017.
//  Copyright © 2017 com.jackwarris. All rights reserved.
//

import Foundation
import CoreData


extension CustomerOrder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CustomerOrder> {
        return NSFetchRequest<CustomerOrder>(entityName: "CustomerOrder")
    }

    @NSManaged public var reference: String?
    @NSManaged public var orderTotal: Double
    @NSManaged public var orderID: NSObject?
    @NSManaged public var orderDrinks: NSSet?
    
}

// MARK: Generated accessors for orderDrinks
extension CustomerOrder {

    @objc(addOrderDrinksObject:)
    @NSManaged public func addToOrderDrinks(_ value: UserDrink)

    @objc(removeOrderDrinksObject:)
    @NSManaged public func removeFromOrderDrinks(_ value: UserDrink)

    @objc(addOrderDrinks:)
    @NSManaged public func addToOrderDrinks(_ values: NSSet)

    @objc(removeOrderDrinks:)
    @NSManaged public func removeFromOrderDrinks(_ values: NSSet)

}
