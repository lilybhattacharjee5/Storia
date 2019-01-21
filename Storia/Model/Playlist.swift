//
//  Playlist.swift
//  Storia
//
//  Created by Lily Bhattacharjee on 1/20/19.
//  Copyright © 2019 Lily Bhattacharjee. All rights reserved.
//

import Foundation

class Playlist {
    
    private var publicStatus: Bool!
    private var name: String!
    private var uri: String!
    private var snapshotId: String!
    private var id: String!
    private var numTracks: Int!
    private var img: UIImage!
    
    init(publicStatus: Bool, name: String, uri: String, id: String, snapshotId: String, numTracks: Int, img: UIImage) {
        self.publicStatus = publicStatus
        self.name = name
        self.uri = uri
        self.id = id
        self.snapshotId = snapshotId
        self.numTracks = numTracks
        self.img = img
    }
    
    // getter methods
    public func getName() -> String {
        return self.name
    }
    
    public func getNumTracks() -> Int {
        return self.numTracks
    }
    
    public func getImg() -> UIImage {
        return self.img
    }
}
