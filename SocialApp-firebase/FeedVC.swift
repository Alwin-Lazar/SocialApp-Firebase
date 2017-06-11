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

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
            print(snapshot.value)
            
        })
    }
    
    // UITableViewDataSource methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
    }
    
    @IBAction func signOutTapped(_ sender: Any) {
        
        // Remove a string value from keychain
        let keyChainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("ALV: Data removed from keyChain \(keyChainResult)")
        
        try! FIRAuth.auth()?.signOut()
        
        dismiss(animated: true, completion: nil)
        
    }
    
}













