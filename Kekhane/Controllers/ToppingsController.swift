//
//  ToppingsController.swift
//  Kekhane
//
//  Created by Jack Warris on 17/06/2017.
//  Copyright © 2017 com.jackwarris. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import CoreData

class ToppingsController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: DECLARATIONS
    
    let dbRef = Database.database().reference(withPath: "topping-items")
    var toppings: [ToppingItem] = []
    var filteredToppings : [ToppingItem] = []
    var selectedDrink : DrinkItem!
    var selectedToppings: [ToppingItem] = []
    var userDrink : UserDrink?
    var userOrder : CustomerOrder?
    var existingUsersOrder : CustomerOrder?
    var managedObjectContext : NSManagedObjectContext!
    
    // MARK: OUTLETS
    
    @IBOutlet weak var toppingCollectionView: UICollectionView!
    @IBOutlet weak var navBar: UINavigationBar!
    
    // MARK: ACTIONS
    
    @IBAction func dismissToppingsView(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createCustomerDrinkObject(_ sender: Any) {
        createCustomersDrink()
        performSegue(withIdentifier: "createDrinkSegue", sender: self)
    }
    
    // MARK: FUNCS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navBar.topItem?.title = "\(self.selectedDrink.name) Toppings"
        view.backgroundColor = (UIColor.brown)
        self.toppingCollectionView.backgroundColor = (UIColor.brown)
        self.toppingCollectionView.allowsMultipleSelection = true
        
        self.toppingCollectionView.delegate = self
        self.toppingCollectionView.dataSource = self
        
        dbRef.observe(.value, with: { snapshot in
            for data in snapshot.children {
                let toppingItem = ToppingItem(snapshot: data as! DataSnapshot)
                self.toppings.append(toppingItem)
            }
            
            // filters toppings based on drink
            let drinkName = self.selectedDrink.name
            if drinkName == "Tea" {
                self.filteredToppings = self.toppings.filter {$0.limit != "C"}
            } else {
                self.filteredToppings = self.toppings.filter {$0.limit != "T"}
            }
            self.toppingCollectionView.reloadData()
        })
    }
    
    func createCustomersDrink() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
            else {
                return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let drinkEntity = NSEntityDescription.entity(forEntityName: "UserDrink", in: managedContext)!
        let orderEntity = NSEntityDescription.entity(forEntityName: "CustomerOrder", in: managedContext)!
        
        let userDrinkObject = UserDrink(entity: drinkEntity, insertInto: managedContext)
        
        var priceTotal = self.selectedDrink.price
        for topping in self.selectedToppings {
            priceTotal = priceTotal + topping.price
        }
        
        userDrinkObject.drinkType = self.selectedDrink.name
        userDrinkObject.price = priceTotal
        
        var toppingsString = String()
        for topping in self.selectedToppings {
            toppingsString.append(topping.name + " ")
        }
        
        userDrinkObject.toppings = toppingsString
        
        if self.existingUsersOrder == nil {
            let userOrderObject = CustomerOrder(entity: orderEntity, insertInto: managedContext)
            userOrderObject.addToOrderDrinks(userDrinkObject)
            self.userOrder = userOrderObject
        } else {
            let existingUserOrderObject = self.existingUsersOrder
            existingUserOrderObject?.addToOrderDrinks(userDrinkObject)
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    // MARK: DELEGATES
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int   {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.filteredToppings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ToppingCollectionCell
        cell.backgroundColor = UIColor.white
        
        let topping = self.filteredToppings[indexPath.row]
        
        cell.toppingNameField?.text = String(topping.name)
        cell.toppingPriceField?.text = String("£\(topping.price)")
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        
        if (self.selectedToppings.count < 2) {
            cell?.layer.borderWidth = 2.0
            cell?.layer.borderColor = UIColor.green.cgColor
            
            self.selectedToppings.append(self.filteredToppings[indexPath.row])
        } else {
            let alert = UIAlertController(title: "Maximum Toppings Selected", message: "You May Only Have 2 Toppings Per Drink", preferredStyle: UIAlertControllerStyle.alert)
            let confirmAction =  UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
            alert.addAction(confirmAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderWidth = 0
        cell?.layer.borderColor = UIColor.gray.cgColor
        
        let toppingToRemove = self.filteredToppings[indexPath.row].name
        self.selectedToppings = self.selectedToppings.filter {$0.name != toppingToRemove}
    }
    
    // MARK: SEGUE
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createDrinkSegue" {
            let destinationViewController = segue.destination as? OrderController
            destinationViewController?.usersOrder = self.userOrder
            destinationViewController?.existingUsersOrder = self.existingUsersOrder
        }
    }
    
}
