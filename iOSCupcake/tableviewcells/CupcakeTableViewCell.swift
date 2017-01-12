//
//  CupcakeTableViewCell.swift
//  iOSCupcake
//
//  Created by Hassan Abid on 8/7/16.
//  Copyright © 2016 Hassan Abid. All rights reserved.
//

import UIKit

class CupcakeTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var cupcakeImage: UIImageView!
    
    @IBOutlet weak var cupcakeName: UILabel!
    
    @IBOutlet weak var rating: RatingControl!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.rating.backgroundColor = UIColor.clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
