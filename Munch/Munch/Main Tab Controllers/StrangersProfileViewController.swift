//
//  StrangersProfileViewController.swift
//  Munch
//
//  Created by Sean Lissner on 13.11.18.
//

import UIKit
import Firebase

class StrangersProfileViewController: UIViewController {

    var posts = [Post]()
    
    @IBOutlet var FeedTableView: UITableView!
    @IBOutlet weak var strangerName: UILabel!
    @IBOutlet weak var strangersAvi: UIImageView!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var numMunches: UILabel!
    @IBOutlet weak var classLevel: UILabel!
    @IBOutlet weak var viewProfile: UIView!
    
    var ref: DatabaseReference!
    
    var USERNAME = ""
    var lblUserNameStranger = ""
    var lblClassificationStranger = ""
    var lblTotalMunchesStranger = ""
    var profileInt = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        strangersAvi.layer.masksToBounds = true
        strangersAvi.layer.cornerRadius = strangersAvi.layer.bounds.width / 2
        strangersAvi.layer.borderWidth = 1
        viewProfile.layer.cornerRadius = 10
        followButton.layer.cornerRadius = 15

        FeedTableView.register(UINib.init(nibName: "FeedTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "FeedTableViewCell")
        
        strangerName.text = lblUserNameStranger
        classLevel.text = lblClassificationStranger
        numMunches.text = lblTotalMunchesStranger
        //set profileInt from database
        loadAvatar(aviInt: profileInt)
    
        disableFollowButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        ref.child("users").observeSingleEvent(of: .value, with: {(snapshot) in
            let dict = snapshot.value as? NSDictionary
            let user_info = dict?[self.USERNAME] as? NSDictionary //Getting Current User's Info from the big Dictionary
            //Miller please give us an A 
            if (user_info != nil){
                //comparing password
                let firstName = user_info?["FirstName"]  as! String
                let lastName = user_info?["LastName"]  as! String
                let classification  = user_info?["Classification"] as! String
                let numMunches = user_info?["NumOfMunches"]  as! Int
                let profileInt = user_info?["Avatar"]  as! Int
                
                self.strangerName.text = firstName + " " + lastName
                self.numMunches.text = String(numMunches) + " Munches"
                self.classLevel.text = classification
                self.loadAvatar(aviInt: profileInt) //Miller, give us an A
            }
        })
        
    self.ref.child("followers").child(LoginViewController.globalVariable.currentUserEmail).observeSingleEvent(of: .value, with: {(snapshot) in
        let dict = snapshot.value as? NSDictionary
        let follower_info = dict?[self.USERNAME] as? Bool //Getting Current User's Info from the big Dictionary
        if (follower_info != nil && follower_info!){
            self.loadPosts()
            self.followButton.setTitle("Following", for: .normal)
        }
    })
        
    }
    
    func disableFollowButton(){
        if LoginViewController.globalVariable.currentUserEmail == self.USERNAME {
            followButton.isHidden = true
        }
    }
    
    func loadAvatar( aviInt: Int){
        if aviInt == 1 {
            strangersAvi.image = UIImage(named: "snoopy")
        }
        else if aviInt == 2 {
            strangersAvi.image = UIImage(named: "nikias")
        }
        else if aviInt == 3 {
            strangersAvi.image = UIImage(named: "tommytrogro")
        }
        else if aviInt == 4 {
            strangersAvi.image = UIImage(named: "wanda")
        }
        else if aviInt == 5 {
            strangersAvi.image = UIImage(named: "cosmo")
        }
        else if aviInt == 6 {
            strangersAvi.image = UIImage(named: "judgejudy")
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
            
            if (!self.posts.contains(tempPost) && authorUsername == self.USERNAME) {
                self.posts.insert(tempPost, at: 0)
                self.FeedTableView.reloadData()
            }
        }
    }
    
    @IBAction func followUser(_ sender: Any) {
        //add to follow table in database
        self.ref.updateChildValues(["/followers/\(LoginViewController.globalVariable.currentUserEmail)/\(self.USERNAME)" : true])
        followButton.setTitle("Following", for: .normal)
        self.loadPosts()
    }
    @IBAction func close(_ sender: Any){
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension StrangersProfileViewController : UITableViewDataSource, UITableViewDelegate {
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
        cell.lblRating.text = String(posts[indexPath
            .row].score) + "/5"
        cell.lblDiningHall.text = posts[indexPath
            .row].diningHall
        cell.lblReview.text = posts[indexPath
            .row].body
        cell.lblreviewerName.text = posts[indexPath
            .row].author
        cell.lblReview.adjustsFontSizeToFitWidth = true
        return cell
        // }
    }
    
    // Handles what happens when users tap on a cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // OPens up the profile of the user at that index
    }
    
}
