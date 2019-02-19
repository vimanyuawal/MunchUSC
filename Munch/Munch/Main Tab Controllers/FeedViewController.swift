//
//  FeedViewController.swift
//  Munch
//
//  Created by Sean Lissner on 01.11.18.
//

import UIKit
import Firebase

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var posts = [Post]()

    @IBOutlet var lblEmptyFeed: UILabel!
    @IBOutlet var FeedTableView: UITableView!
    var selectedRow = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        FeedTableView.register(UINib.init(nibName: "FeedTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "FeedTableViewCell")
       
        ref = Database.database().reference()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        loadPosts()
        
        if posts.isEmpty {
            lblEmptyFeed.isHidden = false
        } else {
            lblEmptyFeed.isHidden = true
        }
    }
    
    var ref: DatabaseReference!
    
    func loadPosts() {
        
        ref.child("posts").observe(.childAdded) { (snapshot: DataSnapshot)  in
            
            let dict = snapshot.value as? [String: Any]
            let authorUsername = dict?["author"]  as! String
            let scoreNum  = dict?["scoreOutOf5"] as! Int
            let author = dict?["authorFirstName"]  as! String
            let diningHall = dict?["selectedDH"]  as! String
            let body = dict?["postBody"]  as! String

            let tempPost = Post(bodyText: body, authorUser: authorUsername, authorText: author, scoreNum: scoreNum, diningHallName: diningHall)
            
            //only displays posts of followed people
            self.ref.child("followers").child(LoginViewController.globalVariable.currentUserEmail).observeSingleEvent(of: .value, with: {(snapshot) in
                let dict = snapshot.value as? NSDictionary
                let follower_info = dict?[authorUsername] as? Bool //Getting Current User's Info from the big Dictionary
            
                if (follower_info != nil && follower_info!){
                    if !self.posts.contains(tempPost) {self.posts.insert(tempPost, at: 0)}
                    self.FeedTableView.reloadData()
                }
            })
        }
    }
    
    @IBAction func newPost(_ sender: Any) {
        performSegue(withIdentifier: "feedToPost", sender: (Any).self)
    }
    
    
    // Number of rows in the table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    // Size of each cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
        //return UITableView.automaticDimension
    }
    
    // Populating cells of table
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    }
    
    // Handles what happens when users tap on a cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.row
        self.performSegue(withIdentifier: "feedToOtherProfile"
            , sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is StrangersProfileViewController
        {
            let vc = segue.destination as? StrangersProfileViewController
            vc?.USERNAME = posts[selectedRow].authorUsername
        }
    }
}
