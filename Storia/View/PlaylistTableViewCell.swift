//
//  PlaylistTableViewCell.swift
//  Storia
//
//  Created by Lily Bhattacharjee on 1/17/19.
//  Copyright © 2019 Lily Bhattacharjee. All rights reserved.
//

import UIKit

class PlaylistTableViewCell: UITableViewCell {

    @IBOutlet var playlistImg: UIImageView!
    @IBOutlet var playlistName: UILabel!
    @IBOutlet var numTracks: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
