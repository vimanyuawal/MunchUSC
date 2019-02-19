//
//  SettingsViewController.swift
//  Munch
//
//  Created by Sean Lissner on 07.11.18.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {
    
    var UsersAvi = 0
    @IBOutlet weak var judyAvi: UIButton!
    @IBOutlet weak var cosmoAvi: UIButton!
    @IBOutlet weak var wandaAvi: UIButton!
    @IBOutlet weak var lnameField: UITextField!
    @IBOutlet weak var fnameField: UITextField!
    @IBOutlet weak var tommyAvi: UIButton!
    @IBOutlet weak var nikiasAvi: UIButton!
    @IBOutlet weak var snoopyAvi: UIButton!
   
    var ref: DatabaseReference!
    
    @IBOutlet weak var saveButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        fnameField.text = LoginViewController.globalVariable.currentUserFirstName
        
         lnameField.text = LoginViewController.globalVariable.currentUserLastName
        saveButton.layer.cornerRadius = 15
        
        tommyAvi.layer.masksToBounds = true
        tommyAvi.layer.cornerRadius = nikiasAvi.layer.bounds.width / 2
       
        nikiasAvi.layer.masksToBounds = true
        nikiasAvi.layer.cornerRadius = nikiasAvi.layer.bounds.width / 2
        
        snoopyAvi.layer.masksToBounds = true
        snoopyAvi.layer.cornerRadius = nikiasAvi.layer.bounds.width / 2
        
        judyAvi.layer.masksToBounds = true
        judyAvi.layer.cornerRadius = judyAvi.layer.bounds.width / 2
        
        cosmoAvi.layer.masksToBounds = true
        cosmoAvi.layer.cornerRadius = cosmoAvi.layer.bounds.width / 2
      
        wandaAvi.layer.masksToBounds = true
        wandaAvi.layer.cornerRadius = wandaAvi.layer.bounds.width / 2
       
        deselectAllAvis()
    }
    

    func deselectAllAvis(){
        let myColor : UIColor = UIColor( red: 0.0, green: 0.0, blue:0.0, alpha: 1.0 )
         cosmoAvi.layer.borderWidth = 3
         wandaAvi.layer.borderWidth = 3
         nikiasAvi.layer.borderWidth = 3
         snoopyAvi.layer.borderWidth = 3
         tommyAvi.layer.borderWidth = 3
         judyAvi.layer.borderWidth = 3
        
        cosmoAvi.layer.borderColor = myColor.cgColor
        wandaAvi.layer.borderColor = myColor.cgColor
        judyAvi.layer.borderColor = myColor.cgColor
        nikiasAvi.layer.borderColor = myColor.cgColor
        snoopyAvi.layer.borderColor = myColor.cgColor
        tommyAvi.layer.borderColor = myColor.cgColor
    }
    func setAviSelected(aviInt: Int){
        let myColor : UIColor = UIColor( red: 0.0, green: 1.0, blue:0.0, alpha: 1.0 )
        switch aviInt {
        case 1: // Snoopy
            deselectAllAvis()
            snoopyAvi.layer.borderWidth = 6
            snoopyAvi.layer.borderColor = myColor.cgColor
        case 2: //Nikias
            deselectAllAvis()
            nikiasAvi.layer.borderWidth = 6
            nikiasAvi.layer.borderColor = myColor.cgColor
        case 3: //Tommy
            deselectAllAvis()
            tommyAvi.layer.borderWidth = 6
            tommyAvi.layer.borderColor = myColor.cgColor
        case 4: //Wanda
            deselectAllAvis()
            wandaAvi.layer.borderWidth = 6
            wandaAvi.layer.borderColor = myColor.cgColor
        case 5: //Cosmo
            deselectAllAvis()
            cosmoAvi.layer.borderWidth = 6
            cosmoAvi.layer.borderColor = myColor.cgColor
        case 6: //Judy
            deselectAllAvis()
            judyAvi.layer.borderWidth = 6
            judyAvi.layer.borderColor = myColor.cgColor
            
        default: break
           
        }
    }
    @IBAction func saveInfo(_ sender: Any) {
        //save fname, lname and aviInt to database
        let firstName = fnameField.text!
        let lastName = lnameField.text!
        
        if (UsersAvi == 0){
            let alertController = UIAlertController(title: "Error!", message: "Please select an Avatar.", preferredStyle: .alert)
            let action2 = UIAlertAction(title: "Dismiss", style: .cancel) { (action:UIAlertAction) in
                print("You've pressed cancel");
            }
            alertController.addAction(action2)
            self.present(alertController, animated: true, completion: nil)
        }
        else{
            self.ref.updateChildValues(["users/\(LoginViewController.globalVariable.currentUserEmail)/FirstName": firstName,
"users/\(LoginViewController.globalVariable.currentUserEmail)/LastName": lastName,
"users/\(LoginViewController.globalVariable.currentUserEmail)/Avatar": UsersAvi,])
            
            LoginViewController.globalVariable.currentUserFirstName = firstName;
            LoginViewController.globalVariable.currentUserLastName = lastName;
        }

        let alertController = UIAlertController(title: "Saved!", message: "Your information has been saved", preferredStyle: .alert)
        
        let action2 = UIAlertAction(title: "Dismiss", style: .cancel) { (action:UIAlertAction) in
            print("You've pressed cancel");
            self.backToProfile(self)
        }
        alertController.addAction(action2)
        
        self.present(alertController, animated: true, completion: nil)
       
    }
 
    @IBAction func makeSnoopyAvi(_ sender: Any) {
        UsersAvi = 1
        setAviSelected(aviInt: UsersAvi)
    }
    
    @IBAction func makeNikiasAvi(_ sender: Any) {
        UsersAvi = 2
        setAviSelected(aviInt: UsersAvi)
    }
    
    @IBAction func makeTommyAvi(_ sender: Any) {
        //add update png in data base
        UsersAvi = 3
        setAviSelected(aviInt: UsersAvi)
    }
    
    @IBAction func makeWandaAvi(_ sender: Any) {
        UsersAvi = 4
        setAviSelected(aviInt: UsersAvi)
    }
    
    @IBAction func makeCosmoAvi(_ sender: Any) {
        UsersAvi = 5
        setAviSelected(aviInt: UsersAvi)
    }
    
    @IBAction func makeJudyAvi(_ sender: Any) {
        UsersAvi = 6
        setAviSelected(aviInt: UsersAvi)
    }
    
    
    @IBAction func backToProfile(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
