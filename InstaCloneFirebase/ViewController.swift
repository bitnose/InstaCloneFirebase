//
//  ViewController.swift
//  InstaCloneFirebase
//
//  Created by Sötnos on 19.8.2021.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    
    // MARK: - IBOutlets
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    
        
    }

    
    // MARK: - IBActions

    // MARK: - Sign in
    @IBAction func signInPressed(_ sender: Any) {
        
        if emailText.text != "" && passwordText.text != "" {
            
            // Try to authenticate
            Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { (authdata, error) in
                
                // If error
                if error != nil {
                    self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error")
                
                // If no errors: Perform a segue
                } else {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        } else {
            // Alert
           makeAlert(titleInput: "Error!", messageInput: "Email/Password?")
        }
    }
    
    // MARK: - Sign up
    @IBAction func signUpPressed(_ sender: Any) {
        
        if emailText.text != "" && passwordText.text != "" {
            
            // Try to create an account and authenticate
            Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { (authdata, error) in
               
                // If error
                if error != nil {
                    self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error")
                
                // If no errors: Perform a segue
                } else {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        } else {
            // Alert
           makeAlert(titleInput: "Error!", messageInput: "Email/Password?")
        }
    }
        
    // MARK: - Make an Alert
    func makeAlert(titleInput: String, messageInput: String) {
        
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}

