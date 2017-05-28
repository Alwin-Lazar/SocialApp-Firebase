//
//  FeedVC.swift
//  SocialApp-firebase
//
//  Created by Alwin Lazar V on 28/05/17.
//  Copyright © 2017 xeoscript. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class FeedVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func signOutPressed(_ sender: Any) {
        
        //Remove a string value from keychain
        let keyChainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("ALV: Data removed from keyChain \(keyChainResult)")
        try! FIRAuth.auth()?.signOut()
        
        performSegue(withIdentifier: "goToSignIn", sender: nil)
        
    }
}
