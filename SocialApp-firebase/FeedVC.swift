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
    
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots {
                    print("SNAP: \(snap)")
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let post = Post.init(postKey: key, postData: postDict)
                        self.posts.append(post)
                    }
                }
            }
           self.tableView.reloadData()
        })
    }
    
    // UITableViewDataSource methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell {
            cell.configureCell(post: post)
            return cell
            
        } else {
            return PostCell()
        }
    }
    
    @IBAction func signOutTapped(_ sender: Any) {
        
        // Remove a string value from keychain
        let keyChainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("ALV: Data removed from keyChain \(keyChainResult)")
        
        try! FIRAuth.auth()?.signOut()
        
        dismiss(animated: true, completion: nil)
        
    }
    
}













