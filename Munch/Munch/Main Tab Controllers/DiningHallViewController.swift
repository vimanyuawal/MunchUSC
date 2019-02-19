
//
//  DiningHallViewController.swift
//  Munch
//
//  Created by Sean Lissner on 25.11.18.
//

import UIKit
import Firebase

class DiningHallViewController: UIViewController {
    
    @IBOutlet weak var dhallView: UIView!
    
    @IBOutlet var lblLifetimeMunches: UILabel!
    
    @IBOutlet var lblHeader: UILabel!
  
    @IBOutlet var imgProfile: UIImageView!
    
    @IBOutlet var btnMenu: UIButton!
    
    @IBOutlet var FeedTableView: UITableView!
    
    var dininghallNum: Int = 0
    var lifetimeMunches: String = ""
    
    var ref: DatabaseReference!
    var posts = [Post]()
    
    var diningHallList = ["EVK", "Parkside", "Village"]

    override func viewDidLoad() {
        super.viewDidLoad()
        dhallView.layer.masksToBounds = true
        dhallView.layer.cornerRadius = 15
        imgProfile.layer.masksToBounds = true
        imgProfile.layer.cornerRadius = imgProfile.layer.bounds.width / 2
        imgProfile.layer.borderWidth = 1
        
        FeedTableView.register(UINib.init(nibName: "FeedTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "FeedTableViewCell")
        
        lblLifetimeMunches.text = lifetimeMunches
        
        if dininghallNum == 1 {
            lblHeader.text = "EVK"
            imgProfile.image = UIImage(named: "evk")
        }
        else if dininghallNum == 2 {
            lblHeader.text = "Parkside"
            imgProfile.image = UIImage(named: "parkside")
        }
        else{
            lblHeader.text = "Village"
            imgProfile.image = UIImage(named: "village")
        }
        // Do any additional setup after loading the view.
        
        ref = Database.database().reference()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        loadPosts()
        
        
    }
    
    func loadPosts() {
        posts.removeAll()
        ref.child("posts").observe(.childAdded) { (snapshot: DataSnapshot)  in
            
            let dict = snapshot.value as? [String: Any]
            let authorUsername = dict?["author"]  as! String
            let scoreNum  = dict?["scoreOutOf5"] as! Int
            let author = dict?["authorFirstName"]  as! String
            let diningHall = dict?["selectedDH"]  as! String
            let body = dict?["postBody"]  as! String
            
            let tempPost = Post(bodyText: body, authorUser: authorUsername, authorText: author, scoreNum: scoreNum, diningHallName: diningHall)
            
            if (diningHall == self.diningHallList[self.dininghallNum-1]) {
                
                self.posts.insert(tempPost, at: 0)
                self.FeedTableView.reloadData()
            }
        }
    }
    
    @IBAction func goToMenu(_ sender: Any) {
        let linkLoader = URLLoader()
        if dininghallNum == 1 { //EVK
            linkLoader.loadLink("https://hospitality.usc.edu/residential-dining-menus//?menu_venue=venue-514&menu_date=" + getDateString(), vc: self)
        }
        else if dininghallNum == 2 { //Parkside
             linkLoader.loadLink("https://hospitality.usc.edu/residential-dining-menus//?menu_venue=venue-518&menu_date=" + getDateString(), vc: self)
        }
        else{
             linkLoader.loadLink("https://hospitality.usc.edu/residential-dining-menus//?menu_venue=venue-27229&menu_date=" + getDateString(), vc: self)
        }
        
    }
    
    
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func getDateString() -> String {
        let date = Date()
        let df = DateFormatter()
        df.dateFormat = "M'/'d'/'y"
        let strDate = df.string(from: date)
        
        return strDate
    }

}

extension DiningHallViewController : UITableViewDataSource, UITableViewDelegate {
    // Number of rows in the table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Will change later to size of sql call results
        return posts.count
    }
    
    // Size of each cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    
    // Populating cells of table
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //if indexPath.row == 0 {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedTableViewCell", for: indexPath) as! FeedTableViewCell
        //cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.lblRating.text = String(posts[indexPath
            .row].score) + "/5"
        cell.lblDiningHall.text = posts[indexPath
            .row].diningHall
        cell.lblReview.text = posts[indexPath
            .row].body
        cell.lblreviewerName.text = posts[indexPath
            .row].author
        return cell
        // }
    }
    
    // Handles what happens when users tap on a cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // OPens up the profile of the user at that index
    }
 
}
