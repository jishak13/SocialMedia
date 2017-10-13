//
//  FeedVC.swift
//  SocialMedia
//
//  Created by Joseph  Ishak on 10/11/17.
//  Copyright © 2017 Joseph  Ishak. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class FeedVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    

    @IBOutlet weak var addImage: CircleView!
    @IBOutlet weak var captionField: FancyField!
    var posts = [Post]()
   
    var imagePicker : UIImagePickerController!
    
    static var imageCache: NSCache<AnyObject,UIImage> = NSCache()
    var imageSelected = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
       tableView.delegate = self
       tableView.dataSource = self
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
    
        DataServices.ds.REF_POSTS.observe(.value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    print("SNAP: \(snap)")
                   
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        self.posts.append(post)
                    }
                }
            }
            self.tableView.reloadData()
        })
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell{
//            var img: UIImage
            
            if let img = FeedVC.imageCache.object(forKey: post.imageUrl as AnyObject){
                cell.configureCell(post: post, img: img)
                return cell
            }else{
                cell.configureCell(post: post)
            return cell
            }
        }else {
                return PostCell()
            }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            addImage.image = image
            imageSelected = true
        } else {
            print("Joe: A Valid image wasnt selected")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addImageTapped(_ sender: AnyObject) {
        present(imagePicker,animated: true,completion:nil)
    }
    
    @IBAction func postButtonTapped(_ sender: Any) {
        
        guard let caption = captionField.text else {
            print("Joe: Caption must be entered")
            return
        }
        guard let img = addImage.image,  imageSelected == true else {
            print("Joe: Image must be selected")
            return
        }
        
        if let imgData = UIImageJPEGRepresentation(img, 0.2) {
            
            let imgUid = NSUUID().uuidString
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            DataServices.ds.REF_POST_IMAGES.child(imgUid).putData(imgData, metadata: metadata) { (metadata,error) in
                if error != nil{
                    print("Joe: Unable to upload image to firebase storage")
                } else {
                    print("Joe: Succesfully uploaded images to firebase storage")
                    let downloadURL = metadata?.downloadURL()?.absoluteString
                }
                
            }
        }
            
        
        
    }
    
    @IBAction func signOutTapped(_ sender: Any) {
        let keychainresult: Bool = KeychainWrapper.standard.removeObject(forKey: "\(KEY_UID)")
        print("Joe: ID Removed from keychain \(keychainresult)" )
        try! Auth.auth().signOut()
        performSegue(withIdentifier: "goToSignIn", sender: nil)
    }

    
}
