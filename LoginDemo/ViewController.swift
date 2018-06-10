//
//  ViewController.swift
//  LoginDemo
//
//  Created by Tran Ngoc Nam on 6/7/18.
//  Copyright © 2018 Tran Ngoc Nam. All rights reserved.
//

import UIKit
import FBSDKLoginKit

typealias DICT = Dictionary<AnyHashable, Any>

class ViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loginButton.layer.cornerRadius = 10
        print(UserDefaults.standard.string(forKey: "email"))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginFacebookAction(sender: AnyObject) {
        let fbLoginManager: FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) -> Void in
            if error == nil {
                let fbLoginResult: FBSDKLoginManagerLoginResult = result!
                if (result?.isCancelled)! {
                    return
                }
                if (fbLoginResult.grantedPermissions.contains("email")) {
                    self.getFBUserData()
                }
            }
        }
    }
    
    func getFBUserData() {
        if FBSDKAccessToken.current() != nil {
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if error == nil {
                    if let info = result as? DICT {
                        if let email = info["email"] as? String,
                            let name = info["name"] as? String,
                            let picture = info["picture"] as? DICT,
                            let data = picture["data"] as? DICT,
                            let url = data["url"] as? String {
                            UserDefaults.standard.set(email, forKey: "email")
                            UserDefaults.standard.set(name, forKey: "name")
                            UserDefaults.standard.set(url, forKey: "url")
                            print(email, name, url)
//                            self.performSegue(withIdentifier: "showTimeLine", sender: nil)
                            
                            //chuyen man
                            let appdelegate = UIApplication.shared.delegate as! AppDelegate
                            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                            let homeViewController = mainStoryboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
                            let nav = UINavigationController(rootViewController: homeViewController)
                            appdelegate.window!.rootViewController = nav
                        }
                    }
                }
            })
        }
    }

}

