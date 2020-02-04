//
//  CustomCell.swift
//  Comviva Twitter
//
//  Created by com.mfs.db on 20/01/20.
//  Copyright © 2020 com.mfs.db. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

    @IBOutlet weak var textViewField: UITextView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var twitterDpView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        twitterDpView.layer.cornerRadius = twitterDpView.frame.size.width / 2
        twitterDpView.clipsToBounds = true
        nameLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        // Configure the view for the selected state
    }
    
}
