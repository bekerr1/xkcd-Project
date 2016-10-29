//
//  XKImageTableViewCell.swift
//  xkcdProject
//
//  Created by brendan kerr on 10/28/16.
//  Copyright © 2016 b3k3r. All rights reserved.
//

import UIKit

class XKImageTableViewCell: UITableViewCell {

    
    @IBOutlet weak var xkcdImage: UIImageView!
    //var xkcdImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //print("Image Cell Frame: \(frame)")
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        print("Cell Selected")
        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //print("Image Cell Frame: \(frame), xkcdimage frame: \(xkcdImage.frame)")
    }

}
