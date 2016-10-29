//
//  XKTitleTableViewCell.swift
//  xkcdProject
//
//  Created by brendan kerr on 10/28/16.
//  Copyright © 2016 b3k3r. All rights reserved.
//

import UIKit

class XKTitleTableViewCell: UITableViewCell {

    
    @IBOutlet weak var imageTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
