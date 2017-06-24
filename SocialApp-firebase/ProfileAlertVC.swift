//
//  ProfileAlertVC.swift
//  SocialApp-firebase
//
//  Created by Alwin Lazar V on 21/06/17.
//  Copyright © 2017 xeoscript. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class ProfileAlertVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var profileImg: CircleImageView!
    @IBOutlet weak var userNameFld: UITextField!
    @IBOutlet weak var errorLbl: UILabel!
    @IBOutlet weak var okeyBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var doneBtn: UIButton!
    
    var alertDict: [String: String]?
    var isSuccessSignIn = false
    var isImgSelected = false
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
    }
    
    func createEmailUser(userName: String, profileImg: UIImage, profileImgUrl: String) {
        if let alertDict = alertDict {
            let email = alertDict["email"]
            let password = alertDict["password"]
            if let email = email, let password = password {
                FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                    
                    if error != nil {
                        print("ALV: Unable to authenticate with firbase using email")
                        self.isSuccessSignIn = false
                    } else {
                        print("ALV: Successfully authenticated with firbase using email")
                        
                        if let user = user {
                            
                            let userData: Dictionary<String, Any> = ["provider": user.providerID, "userName": userName, "profileImgUrl": profileImgUrl]
                            self.completeSignIn(id: user.uid, userData: userData)
                        }
                    }
                })
            }
        }
    }
    
    func completeSignIn(id: String, userData: Dictionary<String, Any>) {
        
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
        
        //Add a string value to keychain
        let keyChainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("ALV: Data saved to keyChain \(keyChainResult)")
        isSuccessSignIn = true
        performSegue(withIdentifier: "FeedVC", sender: nil)
    }
    
    // UIImagePickerController Delegate method
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            profileImg.image = image
            isImgSelected = true
        } else {
            print("ALV: A valid image wasn't selected.")
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func profileImgTapped(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func cancelBtnTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneBtnTapped(_ sender: Any) {
        guard let profileImg = profileImg.image, isImgSelected == true else {
            errorHandler(errorMsg: "Image must be selected.")
            return
        }
        guard let userName = userNameFld.text, userName != "" else {
            errorHandler(errorMsg: "User name must be entered.")
            return
        }
        guard userName.characters.count >= 5 else {
            errorHandler(errorMsg: "User name must be 5 characters Long")
            return
        }
        
        uploadProfileImg(profileImg: profileImg, userName: userName)
    }
    
    func uploadProfileImg(profileImg: UIImage, userName: String) {
        //compress image and set as JPEG
        if let imgData = UIImageJPEGRepresentation(profileImg, 0.2) {
            
            let imgUid = NSUUID().uuidString
            let metaData = FIRStorageMetadata()
            metaData.contentType = "image/jpeg"
            
            DataService.ds.REF_PROFILE_IMAGES.child(imgUid).put(imgData, metadata: metaData, completion: { (metaData, error) in
                
                if error != nil {
                    print("ALV: Unable to upload image to firebase storage")
                    
                } else {
                    
                    print("ALV: Successfully uploaded image to firebase storage")
                    let downloadURL = metaData?.downloadURL()?.absoluteString
                    if let url = downloadURL {
                        
                        self.createEmailUser(userName: userName, profileImg: profileImg, profileImgUrl: url)
                    }
                }
            })
            
        }
    }
    
    func errorHandler(errorMsg: String) {
        //hiding
        profileImg.isHidden = true
        userNameFld.isHidden = true
        cancelBtn.isHidden = true
        doneBtn.isHidden = true
        
        //showing
        errorLbl.isHidden = false
        okeyBtn.isHidden = false
        errorLbl.text = errorMsg
    }
    
    @IBAction func okeyBtnTapped(_ sender: Any) {
        //hiding
        errorLbl.isHidden = true
        okeyBtn.isHidden = true
        
        //showing
        profileImg.isHidden = false
        userNameFld.isHidden = false
        cancelBtn.isHidden = false
        doneBtn.isHidden = false
    }
}




















