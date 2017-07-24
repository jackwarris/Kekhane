//
//  SavedOrdersController.swift
//  Kekhane
//
//  Created by Jack Warris on 17/06/2017.
//  Copyright © 2017 com.jackwarris. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class SavedOrdersController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: DECLARATIONS
    
    var managedObjectContext : NSManagedObjectContext?
    var customerSavedOrders : [CustomerOrder]?
    var selectedOrder : CustomerOrder?
    
    // MARK: OUTLETS
    
    @IBOutlet weak var ordersTable: UITableView!
    
    // MARK: ACTIONS
    
    @IBAction func dismissSavedOrdersView(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: FUNCS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ordersTable.delegate = self
        self.ordersTable.dataSource = self
        view.backgroundColor = (UIColor.brown)
        fetchOrders()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchOrders()
    }
    
    func fetchOrders() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
            else {
                return
        }
        
        self.managedObjectContext = appDelegate.persistentContainer.viewContext
        
        
        let ordersRequest: NSFetchRequest<CustomerOrder> = CustomerOrder.fetchRequest()
        ordersRequest.predicate = NSPredicate(format: "reference.length > 0")
        do {
            let ordersRequestResults = try self.managedObjectContext?.fetch(ordersRequest)
            self.customerSavedOrders = ordersRequestResults
        } catch {
            fatalError("Failed to obtain a routine log: \(error)")
        }
        
    }
    
    // MARK: DELEGATES
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.customerSavedOrders!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SavedOrdersCell
        
        let savedOrder = self.customerSavedOrders?[indexPath.row] as! CustomerOrder //ignore
        cell.savedOrderTitle.text = savedOrder.reference
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedOrder = self.customerSavedOrders?[indexPath.row] as! CustomerOrder
        performSegue(withIdentifier: "userSelectedOrderSegue", sender: self)
    }
    
    // MARK: SEGUES
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "userSelectedOrderSegue" {
            let destinationViewController = segue.destination as? OrderController
            destinationViewController?.existingUsersOrder = self.selectedOrder
        }
    }
    
}
