//
//  DrinksController.swift
//  Kekhane
//
//  Created by Jack Warris on 17/06/2017.
//  Copyright © 2017 com.jackwarris. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

class DrinksController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: OUTLETS
    
    @IBOutlet weak var drinkCollectionView: UICollectionView!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    // MARK: DECLARATIONS
    
    let dbRef = Database.database().reference(withPath: "drink-items")
    var drinks: [DrinkItem] = []
    var selectedDrink : DrinkItem?
    
    var existingUsersOrder : CustomerOrder?
    
    @IBAction func cancelDrinkView(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: FUNCS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = (UIColor.brown)
        self.drinkCollectionView.backgroundColor = (UIColor.brown)
        
        self.drinkCollectionView.delegate = self
        self.drinkCollectionView.dataSource = self
        
        getDrinks()
    }
    
    func getDrinks() {
        dbRef.observe(.value, with: { snapshot in
            for data in snapshot.children {
                let drinkItem = DrinkItem(snapshot: data as! DataSnapshot)
                self.drinks.append(drinkItem)
            }
            self.drinkCollectionView.reloadData()
        })
    }
    
    // MARK: DELEGATES
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int   {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.drinks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DrinkCollectionCell
        cell.backgroundColor = UIColor.white
        
        let drink = self.drinks[indexPath.row]
        cell.drinkNameField?.text = String(drink.name)
        cell.drinkPriceField?.text = String("£\(drink.price)")
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedDrink = self.drinks[indexPath.row]
        performSegue(withIdentifier: "drinkPickedSegue", sender: self)
    }
    
    // MARK: SEGUES
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "drinkPickedSegue" {
            let destinationViewController = segue.destination as? ToppingsController
            destinationViewController?.selectedDrink = self.selectedDrink
            destinationViewController?.existingUsersOrder = self.existingUsersOrder
        }
    }
    
}
