//
//  BrowseViewController.swift
//  Munch
//
//  Created by Sean Lissner on 01.11.18.
//

import UIKit
import Firebase

class BrowseViewController: UIViewController {

    @IBOutlet weak var parksideAvgRating: UILabel!
    @IBOutlet weak var evkAvgRating: UILabel!
    @IBOutlet weak var villageAvgRating: UILabel!
    
    @IBOutlet var btnEvkScore: UIButton!
    @IBOutlet var btnVillageScore: UIButton!
    @IBOutlet var btnParksideScore: UIButton!
    
    @IBOutlet var lblClosedEVK: UILabel!
    @IBOutlet var lblCLosedParkside: UILabel!
    @IBOutlet var lblClosedVillage: UILabel!
    
    @IBOutlet weak var villageView: UIView!
    @IBOutlet weak var parksideView: UIView!
    @IBOutlet weak var evkView: UIView!
    
    @IBOutlet weak var roundedView2: UIView!
    @IBOutlet weak var roundedView1: UIView!
    @IBOutlet weak var roundedView: UIView!
   
    @IBOutlet weak var mealName: UILabel!
    
    var evkLifetimeMunches = 0
    var parksideLifetimeMunches = 0
    var villageLifetimeMunches = 0
    
    var diningHallSegueInt = 0
    var lifetimeMunches = 0
    var isGuest = false
    @IBOutlet var imgFightOn: UIImageView!
    @IBOutlet var btnClose: UIButton!
    var ref = Database.database().reference()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        roundedView.layer.cornerRadius = 15
        roundedView1.layer.cornerRadius = 15
        roundedView2.layer.cornerRadius = 15
        evkView.layer.cornerRadius = 15
        parksideView.layer.cornerRadius = 15
        villageView.layer.cornerRadius = 15
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setTimeDependentLabels()
        populateLabels()
        if isGuest {
            btnClose.isHidden = false
            self.imgFightOn.frame.origin.y = 700
            btnEvkScore.isEnabled = false
            btnParksideScore.isEnabled = false
            btnVillageScore.isEnabled = false
        } else {
            btnClose.isHidden = true
            self.imgFightOn.frame.origin.y = 660
        }
    }
    
    func populateLabels() {
        // Update average score
        ref.child("diningHall").observeSingleEvent(of: .value, with: {(snapshot) in
            let dict = snapshot.value as? NSDictionary
            let diningHall_info = dict?["Parkside"] as? NSDictionary //Getting Current User's Info
            if (diningHall_info != nil){
                let numOfMunches = diningHall_info?["numMunches"] as? Int ?? 0
                let avgRating = diningHall_info?["avgRating"] as? Double ?? 0
                let today = diningHall_info?["todayRating"] as? Double ?? 0
                self.parksideLifetimeMunches = numOfMunches
                self.parksideAvgRating.text = String(format: "%.2f", avgRating)
                self.btnParksideScore.setTitle(String(Int(today.rounded())) + "/5", for: .normal)
            }
        })
        ref.child("diningHall").observeSingleEvent(of: .value, with: {(snapshot) in
            let dict = snapshot.value as? NSDictionary
            let diningHall_info = dict?["EVK"] as? NSDictionary //Getting Current User's Info
            if (diningHall_info != nil){
                let numOfMunches = diningHall_info?["numMunches"] as? Int ?? 0
                let avgRating = diningHall_info?["avgRating"] as? Double ?? 0
                let today = diningHall_info?["todayRating"] as? Double ?? 0
                self.evkLifetimeMunches = numOfMunches
                self.evkAvgRating.text = String(format: "%.2f", avgRating)
                self.btnEvkScore.setTitle(String(Int(today.rounded())) + "/5", for: .normal)
            }
        })
        ref.child("diningHall").observeSingleEvent(of: .value, with: {(snapshot) in
            let dict = snapshot.value as? NSDictionary
            let diningHall_info = dict?["Village"] as? NSDictionary //Getting Current User's Info
            if (diningHall_info != nil){
                let numOfMunches = diningHall_info?["numMunches"] as? Int ?? 0
                let avgRating = diningHall_info?["avgRating"] as? Double ?? 0
                let today = diningHall_info?["todayRating"] as? Double ?? 0
                self.villageLifetimeMunches = numOfMunches
                self.villageAvgRating.text = String(format: "%.2f", avgRating)
                self.btnVillageScore.setTitle(String(Int(today.rounded())) + "/5", for: .normal)
            }
        })
    }
    
    
    @IBAction func toEVKMenu(_ sender: Any) {
        let linkLoader = URLLoader()
        linkLoader.loadLink("https://hospitality.usc.edu/residential-dining-menus//?menu_venue=venue-514&menu_date=" + getDateString(), vc: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is DiningHallViewController
        {
            let vc = segue.destination as? DiningHallViewController
            vc?.dininghallNum = diningHallSegueInt
            vc?.lifetimeMunches = String(lifetimeMunches) + " total Munches"
        }
    }
    
    @IBAction func toEVKProfile(_ sender: Any) {
        diningHallSegueInt = 1
        lifetimeMunches = evkLifetimeMunches
        performSegue(withIdentifier: "browseToDH", sender: (Any).self)
    }
    
    @IBAction func toParksideMenu(_ sender: Any) {
        let linkLoader = URLLoader()
        linkLoader.loadLink("https://hospitality.usc.edu/residential-dining-menus//?menu_venue=venue-518&menu_date=" + getDateString(), vc: self)
    }
    
    @IBAction func toParksideProfile(_ sender: Any) {
        diningHallSegueInt = 2
        lifetimeMunches = parksideLifetimeMunches
        performSegue(withIdentifier: "browseToDH", sender: (Any).self)
    }
    
    @IBAction func toVillageMenu(_ sender: Any){
        let linkLoader = URLLoader()
        linkLoader.loadLink("https://hospitality.usc.edu/residential-dining-menus//?menu_venue=venue-27229&menu_date=" + getDateString(), vc: self)
    }
    @IBAction func toVillageProfile(_ sender: Any) {
        diningHallSegueInt = 3
        lifetimeMunches = villageLifetimeMunches
        performSegue(withIdentifier: "browseToDH", sender: (Any).self)
    }
    
    @IBAction func backToLanding(_ sender: Any) {
        isGuest = false
        btnEvkScore.isEnabled = true
        btnParksideScore.isEnabled = true
        btnVillageScore.isEnabled = true
        self.dismiss(animated: true, completion: nil)
    }
    
    func getDateString() -> String {
        let date = Date()
        let df = DateFormatter()
        df.dateFormat = "M'/'d'/'y"
        let strDate = df.string(from: date)
        
        return strDate
    }
    
    func getSecsFromDayStart() -> Int {
        let date = Date()
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.hour, .minute], from: date)
        let dateSeconds = dateComponents.hour! * 3600 + dateComponents.minute! * 60
        
        return dateSeconds
    }
    
    func setTimeDependentLabels() {
        let dateSeconds = getSecsFromDayStart()
      
        if dateSeconds < 25200 { // Before 7am
            lblClosedEVK.isHidden = false
            lblClosedVillage.isHidden = false
            lblCLosedParkside.isHidden = false
            self.mealName.text = "Tomorrow's Breakfast"
        }
        else if dateSeconds < 37800 { // Before 10:30am
            lblClosedEVK.isHidden = true
            lblClosedVillage.isHidden = true
            lblCLosedParkside.isHidden = true
            self.mealName.text = "Today's Breakfast"
        }
        else if dateSeconds < 39600 { // Before 11:00am
            lblClosedEVK.isHidden = false
            lblClosedVillage.isHidden = false
            lblCLosedParkside.isHidden = false
            self.mealName.text = "Today's Breakfast"
        }
        else if dateSeconds < 54000 { // Before 3:00pm
            lblClosedEVK.isHidden = true
            lblClosedVillage.isHidden = true
            lblCLosedParkside.isHidden = true
            self.mealName.text = "Today's Lunch"
        }
        else if dateSeconds < 61200 { // Before 5pm
            lblCLosedParkside.isHidden = false
            self.mealName.text = "Today's Lunch"
        }
        else if dateSeconds < 79200 { // Before 10pm
            self.mealName.text = "Today's Dinner"
            lblCLosedParkside.isHidden = true
        }
        else { // Before midnight
            lblClosedEVK.isHidden = false
            lblClosedVillage.isHidden = false
            lblCLosedParkside.isHidden = false
            self.mealName.text = "Goodnight"
        }
    }
}
