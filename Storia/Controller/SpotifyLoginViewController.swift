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

class SpotifyLoginViewController: ViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var logout: UIButton!
    @IBOutlet var playlistsTitle: UILabel!
    @IBOutlet var searchBooks: UIButton!
    @IBOutlet var userPlaylists: UITableView!
    @IBOutlet var nowPlaying: UILabel! = UILabel()
    
    fileprivate var lastPlayerState: SPTAppRemotePlayerState?
    
    var currTrack: String = ""
    
    var trackTimer = Timer()
    var accessTokenTimer = Timer()
    
    var accessToken: String! {
        didSet {
            requestPlaylists()
        }
    }
    
    var playlistIds: [String] = []
    var playlists: [Playlist] = []
    
    var noDataLabel: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //accessToken = appRemote.connectionParameters.accessToken
        
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
        
        nowPlaying.text = "Now Playing: Loading..."
        nowPlaying.font = FontScheme.gillsansFont(size: 18)
        nowPlaying.textAlignment = .center
        nowPlaying.lineBreakMode = .byWordWrapping
        nowPlaying.numberOfLines = 2
        
        userPlaylists.dataSource = self
        userPlaylists.delegate = self
        
        scheduledUpdateAccessToken()
        
        scheduledUpdateTrack()
        
    }
    
    func scheduledUpdateAccessToken() {
        accessTokenTimer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(self.updateAccessToken), userInfo: nil, repeats: true)
    }

    @objc func updateAccessToken() {
        if appDelegate.appRemote.connectionParameters.accessToken != nil {
            self.accessToken = appDelegate.appRemote.connectionParameters.accessToken
        }
    }
    
    func scheduledUpdateTrack() {
        trackTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTrack), userInfo: nil, repeats: true)
    }
    
    @objc func updateTrack() {
        if appDelegate.currTrack != nil && self.currTrack != appDelegate.currTrack {
            nowPlaying.text = "Now Playing: " + appDelegate.currTrack
            self.currTrack = appDelegate.currTrack
            nowPlaying.setNeedsDisplay()
            nowPlaying.setNeedsDisplay()
        }
    }
    
    @IBAction func logoutFromSpotify(_ sender: Any) {
        appRemote.disconnect()
        appRemote.connectionParameters.accessToken = ""
    }
    
    @IBAction func searchBooksData(_ sender: Any) {
        
    }
    
    private func requestPlaylists() {
        if accessToken != nil {
            let headers = [
                "Accept": "application/json",
                "Content-Type": "application/json",
                "Authorization": "Bearer " + accessToken
            ]
            
            Alamofire.request(URL(string: "https://api.spotify.com/v1/me/playlists")!, method: .get, encoding: JSONEncoding.default, headers: headers)
                .responseJSON { response in
                    switch response.result {
                    case .success(let data):
                        let json = JSON(data)
                        let playlistItems = json["items"].arrayValue
                        
                        var currPlaylist: Playlist
                        var currPublicStatus: Bool
                        var currName: String
                        var currUri: String
                        var currId: String
                        var currSnapshotId: String
                        var currNumTracks: Int
                        var currImg: UIImage
                        
                        self.playlists = []
                        self.playlistIds = []
                        
                        for playlist in playlistItems {
                            currPublicStatus = playlist["public"].bool ?? false
                            currName = playlist["name"].string ?? ""
                            currUri = playlist["uri"].string ?? ""
                            currId = playlist["id"].string ?? ""
                            currSnapshotId = playlist["snapshot_id"].string ?? ""
                            currNumTracks = playlist["tracks"]["total"].int ?? 0
                            
                            let url = URL(string: playlist["images"][0]["url"].string ?? "")!
                            let data = try? Data(contentsOf: url)
                            currImg = UIImage(data: data!) ?? UIImage()
                            
                            if self.playlistIds.contains(currId) {
                                continue
                            }
                            
                            currPlaylist = Playlist(
                                publicStatus: currPublicStatus,
                                name: currName,
                                uri: currUri,
                                id: currId,
                                snapshotId: currSnapshotId,
                                numTracks: currNumTracks,
                                img: currImg)
                            
                            self.playlists.append(currPlaylist)
                            self.playlistIds.append(currId)
                        }
                        
                        self.userPlaylists.reloadData()
                        self.userPlaylists.setNeedsLayout()
                        self.userPlaylists.setNeedsDisplay()
                    
                    case .failure(let error):
                        print("Request failed with error: \(error)")
                    }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfSections section: Int) -> Int {
        if playlists.count == 0 {
            return 0
        } else {
            userPlaylists.separatorStyle = .singleLine
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.playlists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = userPlaylists.dequeueReusableCell(withIdentifier: "playlist", for: indexPath) as! PlaylistTableViewCell
        let currPlaylist: Playlist = self.playlists[indexPath.row]
        
        cell.playlistName.text = currPlaylist.getName()
        cell.playlistName.font = FontScheme.gillsansFont(size: 20)
        
        cell.numTracks.text = "Number of Tracks: " + String(currPlaylist.getNumTracks())
        cell.numTracks.font = FontScheme.gillsansFont(size: 18)
        
        cell.playlistImg.image = currPlaylist.getImg()
        cell.playlistImg.layer.masksToBounds = true
        cell.playlistImg.layer.cornerRadius = ButtonScheme.padding
        
        return cell
    }
    
    @IBAction func unwindToPlaylistViewController(segue: UIStoryboardSegue, _ sender: Any) {
        
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
