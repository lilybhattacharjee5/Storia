//
//  BookTableViewCell.swift
//  Storia
//
//  Created by Lily Bhattacharjee on 1/21/19.
//  Copyright © 2019 Lily Bhattacharjee. All rights reserved.
//

import UIKit

class BookTableViewCell: UITableViewCell {

    @IBOutlet var bookImg: UIImageView!
    @IBOutlet var bookTitle: UILabel!
    @IBOutlet var author: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
