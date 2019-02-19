//
//  ProfileViewController.swift
//  Munch
//
//  Created by Sean Lissner on 01.11.18.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var posts = [Post]()
    
    @IBOutlet var lblEmptyFeed: UILabel!
    @IBOutlet var profileView: UIView!
    @IBOutlet var imgProfile: UIImageView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblClassification: UILabel!
    @IBOutlet var lblNumMunches: UILabel!
    @IBOutlet var ProfileTableView: UITableView!
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       ProfileTableView.register(UINib.init(nibName: "FeedTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "FeedTableViewCell")
        profileView.layer.cornerRadius = 25
        imgProfile.layer.masksToBounds = true
        imgProfile.layer.cornerRadius = imgProfile.layer.bounds.width/2
        imgProfile.layer.borderWidth = 2
        
        
        ref = Database.database().reference()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        ref.child("users").observeSingleEvent(of: .value, with: {(snapshot) in
            let dict = snapshot.value as? NSDictionary
            let user_info = dict?[LoginViewController.globalVariable.currentUserEmail] as? NSDictionary //Getting Current User's Info from the big Dictionary
            
            if (user_info != nil){
                //comparing password
                let firstName = user_info?["FirstName"]  as! String
                let lastName = user_info?["LastName"]  as! String
                let classification  = user_info?["Classification"] as! String
                let numMunches = user_info?["NumOfMunches"]  as! Int
                let profileInt = user_info?["Avatar"]  as! Int
                
                self.lblName.text = firstName + " " + lastName
                self.lblNumMunches.text = String(numMunches) + " Munches"
                self.lblClassification.text = classification
                self.loadAvatar(aviInt: profileInt)
            }
        })
        loadPosts()
        
//        if posts.isEmpty {
//            lblEmptyFeed.isHidden = false
//        } else {
//            lblEmptyFeed.isHidden = true
//        }
    }
    
    func loadAvatar( aviInt: Int){
        if aviInt == 1 {
            imgProfile.image = UIImage(named: "snoopy")
        }
        else if aviInt == 2 {
            imgProfile.image = UIImage(named: "nikias")
        }
        else if aviInt == 3 {
            imgProfile.image = UIImage(named: "tommytrogro")
        }
        else if aviInt == 4 {
            imgProfile.image = UIImage(named: "wanda")
        }
        else if aviInt == 5 {
            imgProfile.image = UIImage(named: "cosmo")
        }
        else if aviInt == 6 {
            imgProfile.image = UIImage(named: "judgejudy")
        }
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
            
            if (!self.posts.contains(tempPost) && authorUsername == LoginViewController.globalVariable.currentUserEmail) {
                tempPost.author = LoginViewController.globalVariable.currentUserFirstName
                self.posts.insert(tempPost, at: 0)
                self.ProfileTableView.reloadData()
            }
        }
    }
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedTableViewCell", for: indexPath) as! FeedTableViewCell
        cell.lblRating.text = String(posts[indexPath.row].score) + "/5"
        cell.lblDiningHall.text = posts[indexPath
            .row].diningHall
        cell.lblReview.text = posts[indexPath
            .row].body
        cell.lblreviewerName.text = posts[indexPath
            .row].author
        cell.lblReview.adjustsFontSizeToFitWidth = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let lastVisibleIndexPath = tableView.indexPathsForVisibleRows?.last {
            if indexPath == lastVisibleIndexPath {

            }
        }
    }
    

    
    @IBAction func goToSettings(_ sender: Any) {
        performSegue(withIdentifier: "segueToSettings", sender: (Any).self)
    }
}
