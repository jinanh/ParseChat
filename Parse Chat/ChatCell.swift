//
//  ChatCell.swift
//  Parse Chat
//
//  Created by Jinan Huang on 9/23/18.
//  Copyright © 2018 Jinan Huang. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {

    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var chatMessage: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
