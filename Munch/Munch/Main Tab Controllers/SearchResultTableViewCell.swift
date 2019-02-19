//
//  SearchResultTableViewCell.swift
//  Munch
//
//  Created by Sean Lissner on 24.11.18.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {
    
    @IBOutlet var cellView: UIView!
    
    @IBOutlet var imgProfile: UIImageView!
    @IBOutlet var lblStanding: UILabel!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblNumMunches: UILabel!
    var imgInt = 1;
    
    override func awakeFromNib() {
        super.awakeFromNib()

        cellView.layer.cornerRadius = 10
        imgProfile.layer.masksToBounds = true
        imgProfile.layer.cornerRadius = imgProfile.layer.bounds.height/2
        imgProfile.layer.borderWidth = 1

     
    }
    
    func setImage(imgInt: Int){
        switch (imgInt) {
        case 1:
            imgProfile.image = UIImage(named: "snoopy.png")
            break
        case 2:
            imgProfile.image = UIImage(named: "nikias.png")
            break
        case 3:
            imgProfile.image = UIImage(named: "tommyTrojan.png")
            break
        case 4:
            imgProfile.image = UIImage(named: "wanda.png")
            break
        case 5:
            imgProfile.image = UIImage(named: "cosmo.png")
            break
        default:
            imgProfile.image = UIImage(named: "judgejudy.png")
            break
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
