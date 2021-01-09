//
//  MyDataTableViewCell.swift
//  Assignment2
//
//  Created by Xcode User on 2020-11-26.
//  Copyright © 2020 Xcode User. All rights reserved.
//

import UIKit

class MyDataTableViewCell: UITableViewCell {
    @IBOutlet var make : UILabel!
    @IBOutlet var model : UILabel!
    @IBOutlet var year: UILabel!
    @IBOutlet var color : UILabel!
    @IBOutlet var newORused: UILabel!
    @IBOutlet var price : UILabel!
    @IBOutlet var myLogo : UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
