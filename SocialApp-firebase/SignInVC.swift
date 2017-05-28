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

class SignInVC: UIViewController {

    @IBOutlet weak var emailFld: FancyField!
    @IBOutlet weak var passwordFld: FancyField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        //in viewDidLoad can not perform segues.
        
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            performSegue(withIdentifier: "goToFeed", sender: nil)
        }
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
                    
                    self.completeSignIn(id: user.uid)
                    
                }
            }
        })
    }
    
    @IBAction func signInBtnPressed(_ sender: Any) {
        
        if let email = emailFld.text, let password = passwordFld.text {
            
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                
                if error == nil {
                    print("ALV:Email user authenticate with firebase")
                    
                    if let user = user {
                        self.completeSignIn(id: user.uid)
                    }
                    
                } else {
                    
                    FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                        
                        if error != nil {
                            print("ALV: Unable to authenticate with firbase using email")
                        } else {
                            print("ALV: Successfully authenticated with firbase using email")
                            
                            if let user = user {
                                self.completeSignIn(id: user.uid)
                            }
                        }
                    })
                }
            })
        }
    }
    
    
    func completeSignIn(id: String) {
        
        //Add a string value to keychain
        let keyChainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("ALV: Data saved to keyChain \(keyChainResult)")
        
        performSegue(withIdentifier: "goToFeed", sender: nil)
    }
}
























