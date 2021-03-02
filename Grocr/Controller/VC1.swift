//
//  ViewController.swift
//  Grocr
//
//  Created by Жанадил on 2/28/21.
//  Copyright © 2021 Жанадил. All rights reserved.
//

import UIKit
import Firebase

class VC1: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }

    
    //Registration
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        emailTextField.endEditing(true)
        passwordTextField.endEditing(true)
        
        let alert = UIAlertController(title: "REGISTRATION", message: "", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Register", style: .default) { (action) in
            let email = alert.textFields![0].text
            let pass = alert.textFields![1].text
            Auth.auth().createUser(withEmail: email!, password: pass!) { (user, error) in
                if error != nil{
                    if let errorCode = AuthErrorCode(rawValue: error!._code){
                        switch errorCode{
                        case .weakPassword:
                            print("please provide a strong pass")
                        case .emailAlreadyInUse:
                            print("Email is already in use , please select another one")
                        case .invalidEmail:
                            print("Invalid email")
                        default:
                            print("There is an error")
                        }
                    }
                }
                if user != nil{
                    Auth.auth().signIn(withEmail: email!, password: pass!) { (authResult, error) in
                        if let e = error {
                            print(e)
                        }else{
                            self.performSegue(withIdentifier: "segue1", sender: self)
                        }
                    }
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        
        alert.addTextField { (textEmail) in
            textEmail.placeholder = "Email"
        }
        alert.addTextField { (textPassword) in
            textPassword.placeholder = "Password"
        }
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    
    
    //Login
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        emailTextField.endEditing(true)
        passwordTextField.endEditing(true)
        
        if let email = emailTextField.text, let pass = passwordTextField.text{
            Auth.auth().signIn(withEmail: email, password: pass) { (authResult, error) in
                if let e = error {
                    print(e)
                }else{
                    self.performSegue(withIdentifier: "segue1", sender: self)
                }
            }
        }
    }
}



//MARK: UITextField Delegate
extension VC1: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.endEditing(true)
        passwordTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if textField.text != ""{
            return true
        }else{
            textField.placeholder = "Type something"
            return false
        }
    }
}
