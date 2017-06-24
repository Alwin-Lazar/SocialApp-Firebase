//
//  BasicAlertVC.swift
//  SocialApp-firebase
//
//  Created by Alwin Lazar V on 21/06/17.
//  Copyright © 2017 xeoscript. All rights reserved.
//

import UIKit

class BasicAlertVC: UIViewController {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var msgLbl: UILabel!
    
    var alertDict: [String: String]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let alertDict = alertDict {
            let title = alertDict["title"]
            let msg = alertDict["msg"]
            titleLbl.text = title
            msgLbl.text = msg
        } else {
            print("alertDict nil caughted")
        }
    }
    
    @IBAction func DoneTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
