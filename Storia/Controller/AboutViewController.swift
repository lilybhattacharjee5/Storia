//
//  AboutViewController.swift
//  Storia
//
//  Created by Lily Bhattacharjee on 1/17/19.
//  Copyright © 2019 Lily Bhattacharjee. All rights reserved.
//

import UIKit

class AboutViewController: ViewController {

    @IBOutlet var goBackHome: UIButton!
    @IBOutlet var aboutTitle: UILabel!
    @IBOutlet var aboutText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        aboutTitle.font = FontScheme.gillsansFont(size: 50)
        aboutTitle.text = "About"
        
        goBackHome.setTitle("", for: .normal)
        goBackHome.setImage(UIImage(named: "back-icon.png")?.withRenderingMode(.alwaysOriginal), for: .normal)
        
        aboutText.font = FontScheme.gillsansFont(size: 18)
        aboutText.text = ""
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
