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
    @IBOutlet var spotifyLogin: UIButton!
    @IBOutlet var about: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        splashBackground.backgroundColor = ColorScheme.purple
        
        appName.textColor = UIColor.white
        appName.font = FontScheme.gillsansFont(size: 50)
        appName.text = "Storia"
        
        appLogo.image = UIImage(named: "app-logo.png")
        
        spotifyLogin.backgroundColor = ColorScheme.green
        spotifyLogin.setTitle("Login with Spotify", for: .normal)
        spotifyLogin.titleLabel!.font = FontScheme.gillsansFont(size: 24)
        spotifyLogin.layer.cornerRadius = ButtonScheme.padding
        spotifyLogin.setTitleColor(UIColor.black, for: .normal)
        
        about.backgroundColor = ColorScheme.purple
        about.setTitle("About", for: .normal)
        about.titleLabel!.font = FontScheme.gillsansFont(size: 24)
        about.layer.cornerRadius = ButtonScheme.padding
        about.setTitleColor(UIColor.black, for: .normal)
        
    }
    
    @IBAction func goToPlaylists(_ sender: Any) {
        //sessionManager.initiateSession(with: [.appRemoteControl], options: .default)
        performSegue(withIdentifier: "viewPlaylists", sender: sender)
    }
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    func getAccessToken(completion: () -> Void) {
        let requestedScopes: SPTScope = [.appRemoteControl]
        (UIApplication.shared.delegate as! AppDelegate).sessionManager.initiateSession(with: requestedScopes, options: .default)
        print(appRemote.connectionParameters.accessToken)
        completion()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "viewPlaylists" {
            getAccessToken {
                print("done")
            }
        }
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
