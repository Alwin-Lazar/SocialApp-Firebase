//
//  ProfileEditAlertVC.swift
//  SocialApp-firebase
//
//  Created by Alwin Lazar V on 24/06/17.
//  Copyright © 2017 xeoscript. All rights reserved.
//

import UIKit
import Firebase

class ProfileEditAlertVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    @IBOutlet weak var profileImg: CircleImageView!
    @IBOutlet weak var userNameFld: UITextField!
    @IBOutlet weak var errorLbl: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var okeyBtn: UIButton!
    @IBOutlet weak var doneBtn: UIButton!
    
    var profileImgUrlRef: FIRDatabaseReference!
    var userNameRef: FIRDatabaseReference!
    var imagePicker: UIImagePickerController!
    static var profileImageCache: NSCache<NSString, UIImage> = NSCache()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        getDataToDisplay()
    }
    
    func getDataToDisplay() {
        profileImgUrlRef = DataService.ds.REF_USER_CURRENT.child("profileImgUrl")
        userNameRef = DataService.ds.REF_USER_CURRENT.child("userName")
        
        profileImgUrlRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let url = snapshot.value {
                if let profileImg = ProfileEditAlertVC.profileImageCache.object(forKey: url as! NSString) {
                    self.profileImg.image = profileImg
                } else {
                    self.downloadImg(imageUrl: url as! String)
                }
                
            } else {
                self.profileImg.image = UIImage(named: "profile")
            }
            
        })
        
        userNameRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let userName = snapshot.value {
                self.userNameFld.text = userName as? String
            } else {
                print("Error while geting user name")
            }
        })
    }
    
    func downloadImg(imageUrl: String) {
        if imageUrl != nil || imageUrl != "" {
            let ref = FIRStorage.storage().reference(forURL: imageUrl)
            ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
                
                if error != nil {
                    print("ALV: unable to download image from firebase storage")
                } else {
                    print("ALV: Image downloaded from Firebase storage")
                    if let imgData = data {
                        if let img = UIImage(data: imgData) {
                            self.profileImg.image = img
                            ProfileEditAlertVC.profileImageCache.setObject(img, forKey: imageUrl as NSString)
                        }
                    }
                }
            })
            
        } else {
            print("Emty Url Unable to download with that.")
        }
    }
    
    //UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            profileImg.image = image
        } else {
            print("ALV: A valid image wasn't selected.")
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func profileImgTapped(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneTapped(_ sender: Any) {
        guard let profileImg = profileImg.image else {
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
                        self.profileImgUrlRef.setValue(url)
                        self.userNameRef.setValue(userName)
                        self.dismiss(animated: true, completion: nil)
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
    
    @IBAction func okeyTapped(_ sender: Any) {
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





































