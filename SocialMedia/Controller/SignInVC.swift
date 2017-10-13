//
//  ViewController.swift
//  SocialMedia
//
//  Created by Joseph  Ishak on 10/8/17.
//  Copyright © 2017 Joseph  Ishak. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import SwiftKeychainWrapper


class SignInVC: UIViewController {

    @IBOutlet weak var emailField: FancyField!
    @IBOutlet weak var passwordField: FancyField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
    }
    override func viewDidAppear(_ animated: Bool) {
        if let _ : String = KeychainWrapper.standard.string(forKey: "\(KEY_UID)"){
            print("Joe: ID Found in KeyChain")
            performSegue(withIdentifier: "goToFeed", sender: nil)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func facebookButtonTapped(_ sender: Any) {
        
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil{
                print("Joe: unable to authenticate with facebook - \(String(describing: error))")
            }else if result?.isCancelled == true{
                print("Joe: User cancelled Authentication")
            }else{
                print("Joe: Succesfully Authenticated with Facebook")
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }
    }
    func firebaseAuth(_ credential: AuthCredential){
     
        Auth.auth().signIn(with: credential) { (user, error) in
            if error != nil{
                print("Joe: Unable to authenticate with firebase - \(String(describing: error))")
            }else{
                print("Joe: Succesfully Authenticated with FireBase")
                if let user = user{
                    let userData = ["provider":credential.provider]
                    self.completeSignIn(id: user.uid,userData: userData)
                
                }
                
            }
        }
    }
    
    @IBAction func signInTapped(_ sender: Any) {
      
        if let email = emailField.text , let password = passwordField.text{
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                if error == nil{
                    print("Joe: Email authentication with firebase sucessful!")
                    if let user = user{
                        let userData = ["provider":user.providerID]
                        self.completeSignIn(id: user.uid,userData: userData)
                    }
                    
                }else{
                    Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                        if error != nil{
                            print("Joe: Unable to authenticate with FireBase using email")
                        }else{
                            print("Joe: Sucessfully authenticated with firebase")
                            if let user = user{
                                let userData = ["provider":user.providerID]
                                self.completeSignIn(id: user.uid, userData: userData)
                            }
                            
                        }
                    })
                }
            })
            
        }
    }
    func completeSignIn(id: String,userData:Dictionary<String,String>){
       
        let ds = DataServices()
        
        ds.createFirebaseDBUser(uid: id, userData:userData)
        let keychainresult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("Joe: Data saved to keychain \(keychainresult)")
        performSegue(withIdentifier: "goToFeed", sender: nil)
    }
}

