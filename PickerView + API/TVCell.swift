//
//  TVCell.swift
//  PickerView + API
//
//  Created by Appinventiv Mac on 15/03/18.
//  Copyright © 2018 Appinventiv Mac. All rights reserved.
//

import UIKit

class TVCell: UITableViewCell {

    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var nameLB: UILabel!
    @IBOutlet weak var ratingLB: UILabel!
    @IBOutlet weak var addLB: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLB.layer.shadowColor = UIColor.black.cgColor
        nameLB.layer.shadowOffset = CGSize(width: 2, height: 2)
        nameLB.layer.shadowOpacity = 0.8
        nameLB.layer.shadowRadius = 5
        nameLB.layer.masksToBounds = false
        
        innerView.layer.shadowColor = UIColor.black.cgColor
        innerView.layer.shadowOffset = CGSize(width: 5, height: 5)
        innerView.layer.shadowOpacity = 0.8
        innerView.layer.shadowRadius = 5
        innerView.layer.masksToBounds = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
