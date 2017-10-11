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

class FeedVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signOutTapped(_ sender: Any) {
        let keychainresult: Bool = KeychainWrapper.standard.remove(key: "\(KEY_UID)")
        print("Joe: ID Removed from keychain \(keychainresult)" )
        try! Auth.auth().signOut()
        performSegue(withIdentifier: "goToSignIn", sender: nil)
    }
    
    
}
