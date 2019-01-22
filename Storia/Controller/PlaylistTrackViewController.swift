//
//  PlaylistTrackViewController.swift
//  Storia
//
//  Created by Lily Bhattacharjee on 1/21/19.
//  Copyright © 2019 Lily Bhattacharjee. All rights reserved.
//

import UIKit

class PlaylistTrackViewController: ViewController {

    @IBOutlet var goBack: UIButton!
    @IBOutlet var viewTracksTitle: UILabel!
    @IBOutlet var tracksList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        goBack.setBackgroundImage(UIImage(named: "back-icon.png"), for: .normal)
        goBack.setTitle("", for: .normal)
        
        viewTracksTitle.text = "Tracks"
        viewTracksTitle.font = FontScheme.gillsansFont(size: 50)
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
