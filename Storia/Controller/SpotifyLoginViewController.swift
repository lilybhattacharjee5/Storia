//
//  SpotifyLoginViewController.swift
//  Storia
//
//  Created by Lily Bhattacharjee on 1/14/19.
//  Copyright © 2019 Lily Bhattacharjee. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SpotifyKit

class SpotifyLoginViewController: ViewController, SPTSessionManagerDelegate, SPTAppRemoteDelegate, SPTAppRemotePlayerStateDelegate {
    
    @IBOutlet var logout: UIButton!
    @IBOutlet var playlistsTitle: UILabel!
    @IBOutlet var searchBooks: UIButton!
    
    fileprivate let SpotifyClientID = AppInfo.clientID
    fileprivate let SpotifyRedirectURL = URL(string: AppInfo.redirectURL)!

    lazy var configuration: SPTConfiguration = {
        let configuration = SPTConfiguration(clientID: SpotifyClientID, redirectURL: SpotifyRedirectURL)
        configuration.playURI = ""
        
        configuration.tokenSwapURL = URL(string: "https://storia-book.herokuapp.com/api/token")
        configuration.tokenRefreshURL = URL(string: "https://storia-book.herokuapp.com/api/refresh_token")
        
        return configuration
    }()
    
    lazy var sessionManager: SPTSessionManager = {
        let manager = SPTSessionManager(configuration: configuration, delegate: self)
        return manager
    }()
    
    lazy var appRemote: SPTAppRemote = {
        let appRemote = SPTAppRemote(configuration: configuration, logLevel: .debug)
        appRemote.delegate = self
        return appRemote
    }()
    
    fileprivate var lastPlayerState: SPTAppRemotePlayerState?
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        logout.setTitle("Log Out", for: .normal)
        logout.titleLabel?.font = FontScheme.gillsansFont(size: 16)
        logout.layer.cornerRadius = ButtonScheme.padding
        logout.contentEdgeInsets = UIEdgeInsets(top: ButtonScheme.padding, left: ButtonScheme.padding, bottom: ButtonScheme.padding, right: ButtonScheme.padding)
        logout.backgroundColor = ColorScheme.red
        logout.setTitleColor(UIColor.black, for: .normal)
        
        searchBooks.setTitle("Search Books", for: .normal)
        searchBooks.titleLabel?.font = FontScheme.gillsansFont(size: 18)
        searchBooks.layer.cornerRadius = ButtonScheme.padding
        searchBooks.contentEdgeInsets = UIEdgeInsets(top: ButtonScheme.padding, left: ButtonScheme.padding, bottom: ButtonScheme.padding, right: ButtonScheme.padding)
        searchBooks.backgroundColor = ColorScheme.green
        searchBooks.setTitleColor(UIColor.black, for: .normal)
        
        playlistsTitle.text = "Playlists"
        playlistsTitle.font = FontScheme.gillsansFont(size: 50)
        
        let requestedScopes: SPTScope = [.appRemoteControl]
        self.sessionManager.initiateSession(with: requestedScopes, options: .default)
    }
    
    @IBAction func logoutFromSpotify(_ sender: Any) {
        appRemote.disconnect()
        appRemote.connectionParameters.accessToken = ""
    }
    
    func requestPlaylists() {
        let headers = [
            "Accept": "application/json",
            "Content-Type": "application/json",
            "Authorization": "Bearer " + appRemote.connectionParameters.accessToken!
        ]
        
        Alamofire.request(URL(string: "https://api.spotify.com/v1/me/playlists")!, method: .get, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success(let data):
                    let json = JSON(data)
                    let playlistItems = json["items"].arrayValue
                    for i in playlistItems {
                        print(i["name"].stringValue)
                    }
                    print("done")
                case .failure(let error):
                    print("Request failed with error: \(error)")
                }
        }
    }
    
    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
        self.appRemote.connectionParameters.accessToken = session.accessToken
        self.appRemote.connect()
    }

    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
        print("fail", error)
    }

    func sessionManager(manager: SPTSessionManager, didRenew session: SPTSession) {
        print("renewed", session)
    }

    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
        debugPrint("Track name: %@", playerState.track.name)
    }

    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
        self.appRemote.playerAPI?.delegate = self
        self.appRemote.playerAPI?.subscribe(toPlayerState: { (result, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
            } else {
                self.requestPlaylists()
            }
        })
    }

    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
        print("failed")
    }

    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
        print("disconnected")
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
