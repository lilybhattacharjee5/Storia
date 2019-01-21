//
//  ViewController.swift
//  Storia
//
//  Created by Lily Bhattacharjee on 1/13/19.
//  Copyright © 2019 Lily Bhattacharjee. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    internal let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var appRemoteDelegate: SPTAppRemoteDelegate {
        get {
            return UIApplication.shared.delegate as! AppDelegate
        }
    }
    
    var sessionManager: SPTSessionManager {
        get {
            return (UIApplication.shared.delegate as! AppDelegate).sessionManager
        }
    }
    
    var appRemote: SPTAppRemote {
        get {
            return (UIApplication.shared.delegate as! AppDelegate).appRemote
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

}

