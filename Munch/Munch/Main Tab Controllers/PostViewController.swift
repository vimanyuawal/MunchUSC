//
//  PostViewController.swift
//  Munch
//
//  Created by Sean Lissner on 23.11.18.
//

import UIKit
import Firebase

class PostViewController: UIViewController, UITextViewDelegate {
    
    var currentUserEmail = LoginViewController.globalVariable.currentUserEmail;
    
    let diningHalls = ["No Selection","EVK", "Parkside", "Village"]
    var scoreOutOf5 = 1

    @IBOutlet var oneStar: UIButton!
    @IBOutlet var twoStar: UIButton!
    @IBOutlet var threeStar: UIButton!
    @IBOutlet var fourStar: UIButton!
    @IBOutlet var fiveStar: UIButton!
    
    @IBOutlet var lblCharCount: UILabel!
    @IBOutlet var btnSelectDH: UIButton!
    @IBOutlet var lblselectedDH: UILabel!
    @IBOutlet var postBody: UITextView!
    @IBOutlet var btnSubmit: UIButton!
    
    @IBOutlet var viewDH: UIView!
    @IBOutlet var viewPickerSuperView: UIView!
    @IBOutlet var pvDiningHall: UIPickerView!
    @IBOutlet var lblPlaceholder: UILabel!
    
    let gold = UIColor(red: 243.0/255.0, green: 175.0/255.0, blue: 77.0/255.0, alpha: 1.0)
    let cardinal = UIColor(red: 153.0/255.0, green: 27.0/255.0, blue: 30.0/255.0, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnSelectDH.layer.cornerRadius = btnSelectDH.layer.bounds.height/2
        postBody.layer.cornerRadius = 10
        btnSubmit.layer.cornerRadius = btnSelectDH.layer.bounds.height/2
        viewDH.layer.cornerRadius = 5
        viewDH.layer.borderWidth = 2
        viewDH.layer.borderColor = cardinal.cgColor
        
        lblCharCount.text = String(postBody.text.count) +  " Characters"
        
        ref = Database.database().reference()
    }
    
    var ref: DatabaseReference!
    
    // ------------------- NAV BUTTONS ------------------- //
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitMunch(_ sender: Any) {
        
        if lblselectedDH.text == "No Selection" {
            let alertController = UIAlertController(title: "Error", message: "Please select a dining hall", preferredStyle: .alert)
            
            let action2 = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction) in
                print("You've pressed cancel");
            }
            alertController.addAction(action2)
            
            self.present(alertController, animated: true, completion: nil)
        }
        
        // Do all the backend checks
        let autoID = ref.child("posts").childByAutoId().key
        let userPost = ["author" : currentUserEmail,
                        "authorFirstName" : LoginViewController.globalVariable.currentUserFirstName,
            "selectedDH" : lblselectedDH.text,
            "postBody" : postBody.text,
            "scoreOutOf5" : scoreOutOf5,
            ] as [String : Any]
        self.ref.updateChildValues(["/posts/\(autoID!)": userPost,
                                    "/user-posts/\(LoginViewController.globalVariable.currentUserEmail)/\(autoID!)/": userPost])
        let diningHall = lblselectedDH.text!
        let newRating : Float = Float(scoreOutOf5)
        //update number of munches
        ref.child("users").observeSingleEvent(of: .value, with: {(snapshot) in
            let dict = snapshot.value as? NSDictionary
            let user_info = dict?[LoginViewController.globalVariable.currentUserEmail] as? NSDictionary //Getting Current User's Info from the big Dictionary
            
            if (user_info != nil){
                var numOfMunches = user_info?["NumOfMunches"] as? Int ?? 0
                numOfMunches = numOfMunches + 1
                self.ref.updateChildValues(["users/\(LoginViewController.globalVariable.currentUserEmail)/NumOfMunches": numOfMunches])
                
            }
        })
        
        //update average score
        ref.child("diningHall").observeSingleEvent(of: .value, with: {(snapshot) in
            let dict = snapshot.value as? NSDictionary
            let diningHall_info = dict?[diningHall] as? NSDictionary //Getting Current User's Info from the big Dictionary
            
            if (diningHall_info != nil){
                var numOfMunches = diningHall_info?["numMunches"] as? Float ?? 0
                var averageRating = diningHall_info?["avgRating"] as? Float ?? 0
                
                var newAverage : Float = ((averageRating * numOfMunches) + newRating) / (numOfMunches + 1)
                numOfMunches = numOfMunches + 1
                
                var todayMunches = diningHall_info?["todayMunches"] as? Float ?? 0
                var todayRating = diningHall_info?["todayRating"] as? Float ?? 0
                
                var newTodayAverage : Float = ((todayRating * todayMunches) + newRating) / (todayMunches + 1)
                todayMunches = todayMunches + 1
                
                self.ref.updateChildValues(["diningHall/\(diningHall)/numMunches": numOfMunches,
                                            "diningHall/\(diningHall)/avgRating": newAverage,
                                            "diningHall/\(diningHall)/todayMunches": todayMunches,
                                            "diningHall/\(diningHall)/todayRating": newTodayAverage])
            }
        })
        self.dismiss(animated: true, completion: nil)
    }
    
    // ------------------- TEXTVIEW FUNCTIONS ------------------- //
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
//        if postBody.text.count == 0 {
//            lblPlaceholder.isHidden = false
//        } else {
//            lblPlaceholder.isHidden = true
//        }
        if lblPlaceholder.isHidden == false {
            lblPlaceholder.isHidden = true
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.count == 0 {
            lblPlaceholder.isHidden = false
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        lblCharCount.text = String(postBody.text.count) +  " Characters"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    
    // ------------------- PICKER FUNCTIONS ------------------- //

    
    @IBAction func presentPicker(_ sender: Any) {
        pvDiningHall.selectRow(findDiningHallRow(), inComponent: 0, animated: false)
        presentPicker()
    }
    
    @IBAction func dismissPicker(_ sender: Any) {
        dismissPicker()
    }
    
    func findDiningHallRow() -> Int {
        if lblselectedDH.text == "No Selection" {
            return 0
        }
        else {
            return diningHalls.index(of: lblselectedDH.text!)!
        }
    }
    
    func presentPicker() {
        viewPickerSuperView.translatesAutoresizingMaskIntoConstraints = true
        
        //Previous Frame of the view 547
        UIView.animate(withDuration: 0.5) {
            self.viewPickerSuperView.frame = CGRect(x: 0.0, y: (self.view.frame.size.height - self.viewPickerSuperView.frame.size.height), width: UIScreen.main.bounds.size.width, height: self.viewPickerSuperView.frame.size.height)
        }
    }
    
    func dismissPicker() {
        viewPickerSuperView.translatesAutoresizingMaskIntoConstraints = true
        
        //Previous Frame of the view 547
        UIView.animate(withDuration: 0.5) {
            self.viewPickerSuperView.frame = CGRect(x: 0.0, y: 1000.0, width: UIScreen.main.bounds.size.width, height: self.viewPickerSuperView.frame.size.height)
        }
    }
    
    // ------------------- STARS LOGIC ------------------- //

    @IBAction func oneStar(_ sender: Any) {
        scoreOutOf5 = 1
        twoStar.setImage(UIImage(named: "starEmpty.png"), for: .normal)
        threeStar.setImage(UIImage(named: "starEmpty.png"), for: .normal)
        fourStar.setImage(UIImage(named: "starEmpty.png"), for: .normal)
        fiveStar.setImage(UIImage(named: "starEmpty.png"), for: .normal)
    }
    
    @IBAction func twoStar(_ sender: Any) {
        scoreOutOf5 = 2
        twoStar.setImage(UIImage(named: "starFilled.png"), for: .normal)
        threeStar.setImage(UIImage(named: "starEmpty.png"), for: .normal)
        fourStar.setImage(UIImage(named: "starEmpty.png"), for: .normal)
        fiveStar.setImage(UIImage(named: "starEmpty.png"), for: .normal)
    }
    
    @IBAction func threeStar(_ sender: Any) {
        scoreOutOf5 = 3
        twoStar.setImage(UIImage(named: "starFilled.png"), for: .normal)
        threeStar.setImage(UIImage(named: "starFilled.png"), for: .normal)
        fourStar.setImage(UIImage(named: "starEmpty.png"), for: .normal)
        fiveStar.setImage(UIImage(named: "starEmpty.png"), for: .normal)
    }
    
    @IBAction func fourStar(_ sender: Any) {
        scoreOutOf5 = 4
        twoStar.setImage(UIImage(named: "starFilled.png"), for: .normal)
        threeStar.setImage(UIImage(named: "starFilled.png"), for: .normal)
        fourStar.setImage(UIImage(named: "starFilled.png"), for: .normal)
        fiveStar.setImage(UIImage(named: "starEmpty.png"), for: .normal)
        
    }
    
    @IBAction func fiveStar(_ sender: Any) {
        scoreOutOf5 = 5
        twoStar.setImage(UIImage(named: "starFilled.png"), for: .normal)
        threeStar.setImage(UIImage(named: "starFilled.png"), for: .normal)
        fourStar.setImage(UIImage(named: "starFilled.png"), for: .normal)
        fiveStar.setImage(UIImage(named: "starFilled.png"), for: .normal)
    }
}


extension PostViewController : UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 4
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return diningHalls[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewDH.layer.borderColor = gold.cgColor
        lblselectedDH.text = diningHalls[row]
    }
}
