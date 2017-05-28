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

class SignInVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            }
            
        })
        
    }
}
























