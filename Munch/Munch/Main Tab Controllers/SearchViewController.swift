//
//  SearchViewController.swift
//  Munch
//
//  Created by Sean Lissner on 23.11.18.
//

import UIKit
import Firebase

class SearchViewController: UIViewController {
    
    var users = [Profile]()
    var selectedRow = -1
    
    @IBOutlet weak var searchFriendField: UITextField!
    @IBOutlet var searchTableView: UITableView!
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchFriendField.layer.masksToBounds = true
        searchFriendField.layer.cornerRadius = 15
        // Do any additional setup after loading the view.
        
        ref = Database.database().reference()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        searchFriendField.text = ""
        users.removeAll()
        searchTableView.reloadData()
    }
    
    @IBAction func searchFriends(_ sender: Any) {
        users.removeAll()
        searchTableView.reloadData()
        
        //use searchFriendField to query database
        let searchTerm = searchFriendField.text!
        
        ref.child("users").observe(.childAdded) { (snapshot: DataSnapshot)  in
            let id = snapshot.key
            
            if (id.contains(searchTerm)) {
                let dict = snapshot.value as? [String: Any]
                let firstName = dict?["FirstName"]  as! String
                let lastName = dict?["LastName"]  as! String
                let classification  = dict?["Classification"] as! String
                let numMunches = dict?["NumOfMunches"]  as! Int
                let avatar = dict?["Avatar"]  as! Int
                
                let tempUser = Profile(fName: firstName, lName: lastName, user: id, userClass: classification, profile: avatar, numMunch: numMunches)
                self.users.insert(tempUser, at: 0)
                self.searchTableView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is StrangersProfileViewController
        {
            let vc = segue.destination as? StrangersProfileViewController
            vc?.lblClassificationStranger = users[selectedRow].classification
            vc?.lblUserNameStranger = users[selectedRow].firstName + " " + users[selectedRow].lastName
            vc?.lblTotalMunchesStranger = String(users[selectedRow].numMunches) + " Munches"
            vc?.profileInt = users[selectedRow].profileInt
            vc?.USERNAME = users[selectedRow].username
        }
    }
}

extension SearchViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultTableViewCell", for: indexPath) as! SearchResultTableViewCell
        cell.lblName.text = users[indexPath.row].firstName + " " + users[indexPath.row].lastName
        cell.lblStanding.text = users[indexPath.row].classification
        cell.lblNumMunches.text = String(users[indexPath.row].numMunches) + " Munches"
        cell.setImage(imgInt: users[indexPath.row].profileInt)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.row
        self.performSegue(withIdentifier: "searchToStranger", sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
}
