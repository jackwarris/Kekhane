//
//  OrderController.swift
//  Kekhane
//
//  Created by Jack Warris on 17/06/2017.
//  Copyright © 2017 com.jackwarris. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

class OrderController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    // MARK: DECLARATIONS
    
    let dbRef = Database.database().reference(withPath: "order-items")
    var usersOrder : CustomerOrder?
    var ordersDrinks : [UserDrink]?
    var userOrderCommit : CustomerOrder?
    var existingUsersOrder : CustomerOrder?
    var orderTotal = 0.0
    
    // MARK: OUTLETS
    
    @IBOutlet weak var ordersTable: UITableView!
    @IBOutlet weak var orderTotalLabel: UILabel!
    @IBOutlet weak var customerReferenceTextfield: UITextField!
    
    // MARK: ACTIONS
    
    @IBAction func dismissConfirmOrderView(_ sender: Any) {
        // this needs to unwind to the home controller not the drink maker
        navigationController?.popToRootViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func confirmOrderPresed(_ sender: Any) {
        createOrder()
    }
    
    @IBAction func saveForLaterPressed(_ sender: Any) {
        saveForLater()
    }
    
    
    @IBAction func addAnotherDrinkPressed(_ sender: Any) {
        performSegue(withIdentifier: "addAditionalDrink", sender: self)
    }
    
    // MARK: FUNCS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = (UIColor.brown)
        self.ordersTable.delegate = self
        self.ordersTable.dataSource = self
        self.customerReferenceTextfield.delegate = self
        self.customerReferenceTextfield.isAccessibilityElement = true
        self.customerReferenceTextfield.autocorrectionType = .no
        calculateOrdersDrinks()
    }
    
    func calculateOrdersDrinks() {
        if self.existingUsersOrder == nil {
            self.ordersDrinks = self.usersOrder?.orderDrinks?.allObjects as! [UserDrink]
        } else {
            self.ordersDrinks = self.existingUsersOrder?.orderDrinks?.allObjects as! [UserDrink]
            self.customerReferenceTextfield.text = self.existingUsersOrder?.reference
        }
        calculateOrderTotal()
    }
    
    func calculateOrderTotal() {
        for drinks in self.ordersDrinks! {
            self.orderTotal = self.orderTotal + drinks.price
        }
        self.orderTotalLabel.text = ("£\(String(describing: self.orderTotal))")
    }
    
    
    func createOrder() {
        if self.customerReferenceTextfield.text != "" {
            if self.existingUsersOrder == nil {
                self.userOrderCommit = self.usersOrder
            } else {
                self.userOrderCommit = self.existingUsersOrder
            }
            
            self.userOrderCommit?.reference = self.customerReferenceTextfield.text
            self.userOrderCommit?.orderTotal = self.orderTotal
            
            let commitOrderDrinks = self.userOrderCommit?.orderDrinks?.allObjects as! [UserDrink]
            var drinkString = ""
            
            for drink in commitOrderDrinks {
                drinkString.append(drink.drinkType! + " " + drink.toppings! + " ")
            }
            
            let postOrder:[String : AnyObject] = [
                "referenceName":self.userOrderCommit?.reference as AnyObject,
                "orderTotal":self.userOrderCommit?.orderTotal as AnyObject,
                "orderDrinks":drinkString as AnyObject
            ]
            
            let firebaseRef = Database.database().reference()
            firebaseRef.child("customer-orders").childByAutoId().setValue(postOrder)
            
            performSegue(withIdentifier: "confirmOrderSegue", sender: self)
        } else {
            referenceNeededAlert()
        }
    }
    
    func saveForLater() {
        if self.customerReferenceTextfield.text != "" {
            if self.existingUsersOrder == nil {
                self.userOrderCommit = self.usersOrder
            } else {
                self.userOrderCommit = self.existingUsersOrder
            }
            userOrderCommit?.reference = self.customerReferenceTextfield.text
            userOrderCommit?.orderTotal = self.orderTotal
            
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
                else {
                    return
            }
            
            let managedContext = appDelegate.persistentContainer.viewContext
            
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
            performSegue(withIdentifier: "confirmOrderSegue", sender: self)
            
        } else {
            referenceNeededAlert()
        }
    }
    
    func referenceNeededAlert() {
        let alert = UIAlertController(title: "Order Reference Missing", message: "Please Enter An Order Reference Name", preferredStyle: UIAlertControllerStyle.alert)
        let confirmAction =  UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
        alert.addAction(confirmAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: DELEGATES
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.ordersDrinks!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DrinkOrderCell
        
        let drinkOrder = self.ordersDrinks?[indexPath.row] as! UserDrink
        
        cell.customerDrinkToppings.text = drinkOrder.toppings
        cell.customerDrinkName.text = drinkOrder.drinkType
        cell.customerDrinkPrice.text = String(describing: drinkOrder.price)
        
        return cell
    }
    
    // MARK: SEGUES
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addAdditionalDrink" {
            let destinationViewController = segue.destination as? DrinksController
            if self.existingUsersOrder == nil {
                destinationViewController?.existingUsersOrder = self.usersOrder
            } else {
                destinationViewController?.existingUsersOrder = self.existingUsersOrder
            }
        }
    }
    
}
