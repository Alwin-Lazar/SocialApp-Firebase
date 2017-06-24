//
//  ViewController.swift
//  SocialApp-firebase
//
//  Created by Alwin Lazar V on 23/05/17.
//  Copyright © 2017 xeoscript. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import SwiftKeychainWrapper

class SignInVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailFld: FancyField!
    @IBOutlet weak var passwordFld: FancyField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailFld.delegate = self
        passwordFld.delegate = self
        
        registerForKeyboardNotifications()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        //in viewDidLoad can not perform segues.
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            performSegue(withIdentifier: "goToFeed", sender: nil)
        }
    }
    
    func registerForKeyboardNotifications(){
        
        //Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWasShown(notification: NSNotification) {
        print("ALV:keyboardWasShown")
    }
    
    func keyboardWillBeHidden(notification: NSNotification) {
        print("ALV:keyboardWillBeHidden")
    }
    
    func deregisterFromKeyboardNotifications(){
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    //TextField Delegate Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == self.emailFld {
            self.passwordFld.becomeFirstResponder()
        } else if textField == self.passwordFld {
            self.done()
            self.passwordFld.resignFirstResponder()
        }
        return true
    }
    
    func done() {
        print("ALV: Done pressed")
        validatedEmailSignIn()
    }
    
    @IBAction func facebookBtnPressed(_ sender: Any) {
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            
            //error occured
            if error != nil {
                
                print("ALV: Unable to authenticate with Facebook - \(String(describing: error))")
                
            } else if result?.isCancelled == true {
                // when the user cancell using fb auth then it handle here.
                
                print("ALV: User cancelled facebook authentication")
                
            } else {
                
                print("ALV: Successfully authenticated with facebook authentication")
                
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                
                self.firebaseAuth(credential)
            }
        }
    }
    
    func firebaseAuth(_ credential: FIRAuthCredential) {
        
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            
            if error != nil {
                print("ALV: Unable to authenticate with Firebase - \(String(describing: error))")
            } else {
                print("ALV: Successfully authenticated with Firebase")
                
                if let user = user {
                    let userData = ["provider": credential.provider]
                    self.completeSignIn(id: user.uid, userData: userData)
                    
                }
            }
        })
    }
    
    @IBAction func signInBtnPressed(_ sender: Any) {
        validatedEmailSignIn()
    }
    
    func validatedEmailSignIn() {
        if emailFld.text == nil || emailFld.text == "" {
            showAlert(msg: "Email is required.")
            
        } else if passwordFld.text == nil || passwordFld.text == "" {
            showAlert(msg: "Password is required.")
            
        } else {
            emailSignIn(email: emailFld.text!, password: passwordFld.text!)
        }
    }
    
    func showAlert(title: String = "Sign In Error", msg: String) {
        let alertDict = ["title": title, "msg": msg]
        
        performSegue(withIdentifier: "BasicAlert", sender: alertDict)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "BasicAlert" {
            if let destination = segue.destination as? BasicAlertVC {
                if let alertDict = sender as? [String: String] {
                    destination.alertDict = alertDict
                }
            }
        } else if segue.identifier == "ProfileAlert" {
            if let destination = segue.destination as? ProfileAlertVC {
                if let alertDict = sender as? [String: String] {
                    destination.alertDict = alertDict
                }
            }
        }
    }
    
    func emailSignIn(email: String, password: String) {
        //sign in
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            
            if error == nil {
                print("ALV:Email user authenticate with firebase")
                
                if let user = user {
                    let userData = ["provider": user.providerID]
                    self.completeSignIn(id: user.uid, userData: userData)
                }
                
            } else {
                // create a user
                let alertDict = ["email": email, "password": password]
                
                self.performSegue(withIdentifier: "ProfileAlert", sender: alertDict)
            }
        })
    }
    
    
    func completeSignIn(id: String, userData: Dictionary<String, String>) {
        
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
        
        //Add a string value to keychain
        let keyChainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("ALV: Data saved to keyChain \(keyChainResult)")
        
        performSegue(withIdentifier: "goToFeed", sender: nil)
    }
    
    // email validation method
    func isValidEmail(emailAddress:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: emailAddress)
    }
}
























