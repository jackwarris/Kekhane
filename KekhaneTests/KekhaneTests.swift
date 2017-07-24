//
//  KekhaneTests.swift
//  KekhaneTests
//
//  Created by Jack Warris on 17/06/2017.
//  Copyright © 2017 com.jackwarris. All rights reserved.
//

import XCTest
import CoreData

@testable import Kekhane

class DrinksViewControllerTest: XCTestCase {
    
    var orderVc : OrderController!
    
    override func setUp() {
        super.setUp()
        // creates a VC instance
        self.orderVc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController (withIdentifier:"OrderController") as!OrderController
    }
    
    override func tearDown() {
        super.tearDown()
        // teats down VC Instance for isolation of testing
        orderVc = nil
    }
    
    func testOrderAddsUp() {
        
        // creates mock core data managed objects in memory for drinks and container order == user definable properties
        let managedObjectContext = setUpInMemoryManagedObjectContext()
        let drinkproduct = NSEntityDescription.insertNewObject(forEntityName: "UserDrink", into: managedObjectContext) as! UserDrink
        let drinkproduct2 = NSEntityDescription.insertNewObject(forEntityName: "UserDrink", into: managedObjectContext) as! UserDrink
        // only set price for this test
        drinkproduct.price = 2.00
        drinkproduct2.price = 1.50
        
        let userOrder = NSEntityDescription.insertNewObject(forEntityName: "CustomerOrder", into: managedObjectContext) as! CustomerOrder
        userOrder.addToOrderDrinks(drinkproduct)
        userOrder.addToOrderDrinks(drinkproduct2)
        
        // injects mock object into VC
        self.orderVc.usersOrder = userOrder
        
        // inits the VC which calls calculation methods to test the view init calcualtion works
        // focuses on calculateOrdersDrinks and calculateOrderTotal methods validity
        _ = self.orderVc.view
        
        // checks its true that the VC after loading holds a value for the customers order based on the above methods logic validity
        XCTAssertTrue((self.orderVc.orderTotal) > 0.0)
    }

    func setUpInMemoryManagedObjectContext() -> NSManagedObjectContext {
        // creates a managed object context instance to work on mock object
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        } catch {
            print("Adding in-memory persistent store failed")
        }
        let managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        return managedObjectContext
    }
    
}
