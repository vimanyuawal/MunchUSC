//
//  FeedTableViewCell.swift
//  Munch
//
//  Created by Sean Lissner on 13.11.18.
//

import UIKit

class FeedTableViewCell: UITableViewCell {

    @IBOutlet var cellView: UIView!
    @IBOutlet var scoreView: UIView!
    
    @IBOutlet var lblreviewerName: UILabel!
    @IBOutlet var lblDiningHall: UILabel!
    @IBOutlet var lblReview: UILabel!
    @IBOutlet var lblRating: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        cellView.layer.cornerRadius = 15
        scoreView.layer.borderWidth = 3
        scoreView.layer.cornerRadius = scoreView.layer.bounds.height / 2
        scoreView.layer.borderColor = UIColor(red: 245.0/255.0, green: 176.0/255.0, blue: 65.0/255.0, alpha: 1.0).cgColor
        //lblRating.text = "."
        
    }
}
