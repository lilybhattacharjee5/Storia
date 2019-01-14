//
//  HomeScreenViewController.swift
//  Storia
//
//  Created by Lily Bhattacharjee on 1/13/19.
//  Copyright © 2019 Lily Bhattacharjee. All rights reserved.
//

import UIKit

class HomeScreenViewController: ViewController {

    @IBOutlet var splashBackground: UIView!
    @IBOutlet var appName: UILabel!
    @IBOutlet var appLogo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        splashBackground.backgroundColor = ColorScheme.purple
        
        appName.textColor = UIColor.white
        appName.font = FontScheme.gillsans50
        appName.text = "Storia"
        
        appLogo.image = UIImage(named: "app-logo.png")
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
