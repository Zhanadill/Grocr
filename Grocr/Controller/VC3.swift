//
//  VC3.swift
//  Grocr
//
//  Created by Жанадил on 3/1/21.
//  Copyright © 2021 Жанадил. All rights reserved.
//

import UIKit
import Firebase

class VC3: UITableViewController {
    let usersReference = Database.database().reference(withPath: "online")
    var arr: [User] = []
    var user_id:String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func logOutButtonPressed(_ sender: UIBarButtonItem) {
        do{
            try Auth.auth().signOut()
            let currentUserRefence = self.usersReference.child(user_id!)
            currentUserRefence.removeValue()
            navigationController?.popToRootViewController(animated: true)
        }catch let signOutError as NSError{
            print(signOutError)
        }
    }
}



//MARK: TableView DataSource Methods
extension VC3{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath)
        cell.textLabel?.text = arr[indexPath.row].email
        return cell
    }
}
