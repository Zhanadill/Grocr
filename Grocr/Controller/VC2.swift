//
//  VC2.swift
//  Grocr
//
//  Created by Жанадил on 2/28/21.
//  Copyright © 2021 Жанадил. All rights reserved.
//

import UIKit
import Firebase

class VC2: UITableViewController {
    @IBOutlet weak var userCountBarButton: UIBarButtonItem!
    let groceryItemReference = Database.database().reference(withPath: "grocery-items")
    let usersReference = Database.database().reference(withPath: "online")
    var arr = [Item]()
    var arr2 = [User]()
    var user_id: String?
    var user = User(uid: "", email: "")
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "myCell", bundle: nil), forCellReuseIdentifier: "cell1")
        tableView.rowHeight = 60
        
        
        //We fetched the data
        groceryItemReference.queryOrdered(byChild: "completed").observe(.value, with: {
            snapshot in
            var newItems: [Item] = []
            for item in snapshot.children{
                let groceryItem = Item(snapshot: item as! DataSnapshot)
                newItems.append(groceryItem!)
            }
            self.arr = newItems
            self.tableView.reloadData()
        })
        
        
        //We added new branch that stores info about online user
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                let currentUserRefence = self.usersReference.child(user.uid)
                let values: [String: String] = ["uid": user.uid,
                                             "email": user.email!]
                self.user_id = user.uid
                currentUserRefence.setValue(values)
                currentUserRefence.onDisconnectRemoveValue()
            }
        }
        
        
        //BarButton shows count of current online users
        usersReference.observe(.value , with: {
            snapshot in
            if snapshot.exists(){
                self.userCountBarButton.title = snapshot.childrenCount.description
            }else{
                self.userCountBarButton.title = "0"
            }
            var newItems: [User] = []
            for item in snapshot.children{
                let userItem = User(snapshot: item as! DataSnapshot)
                newItems.append(userItem!)
            }
            self.arr2 = newItems
        })
    }
    
    
    
    //Opens new window that shows current online users
    @IBAction func userCountBarButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "segue2", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue2"{
            if let selectVC = segue.destination as? VC3{
                selectVC.arr = arr2
                selectVC.user_id = user_id
            }
        }
    }
    
    
    
    //Add Button Pressed
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "ADD ITEM", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "ADD", style: .default) { (action) in
            let groceryItemRef = self.groceryItemReference.child(textField.text!.lowercased())
            let values: [String: Any] = ["text": textField.text!.lowercased(),
                                         "author": Auth.auth().currentUser?.email ?? "",
                                         "completed": false]
            groceryItemRef.setValue(values)
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    
    //Function that is responsible for checkmark accessory of Item
    func toggleCellCheckBox(_ cell: myCell, isCompleted: Bool){
           if isCompleted{
               cell.accessoryType = .none
               cell.itemLabel.textColor = UIColor.black
               cell.authorLabel.textColor = UIColor.black
           }else{
               cell.accessoryType = .checkmark
               cell.itemLabel.textColor = UIColor.gray
               cell.authorLabel.textColor = UIColor.gray
           }
       }
}



//MARK: TableView DataSource Methods
extension VC2{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! myCell
        cell.itemLabel.text = arr[indexPath.row].text
        cell.authorLabel.text = arr[indexPath.row].author
        toggleCellCheckBox(cell, isCompleted: !arr[indexPath.row].completed)
        return cell
    }
}



//MARK: TableView Delegate Methods
extension VC2{
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let groceryItem = arr[indexPath.row]
        arr[indexPath.row].completed = !groceryItem.completed
        groceryItem.ref?.updateChildValues(["completed": !groceryItem.completed])
        tableView.reloadData()
    }
}



//MARK: TableView Delete Methods
extension VC2{
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let groceryItem = arr[indexPath.row]
            groceryItem.ref?.removeValue()
            arr.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
}
