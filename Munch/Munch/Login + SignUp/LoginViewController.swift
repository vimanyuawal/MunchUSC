//
//  SignUpViewController.swift
//  Munch
//
//  Created by Sean Lissner on 01.11.18.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {

    struct globalVariable{
        static var currentUserEmail = "";
        static var currentUserFirstName = "";
        static var currentUserLastName = "";
    }
    
    @IBOutlet weak var munchButton: UIButton!
    @IBOutlet weak var emailParameter: UITextField!
    @IBOutlet weak var passwrdParam: UITextField!
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailParameter.delegate = self
        passwrdParam.delegate = self
        emailParameter.becomeFirstResponder()
        munchButton.layer.cornerRadius = munchButton.layer.bounds.height / 2
        
        ref = Database.database().reference()
    }
    
    @IBAction func backToLanding(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    
    @IBAction func verifyLogin(_ sender: Any) {
        if(!(emailParameter.text?.isEmpty)! && (emailParameter.text?.contains("@usc.edu"))! && !(passwrdParam.text?.isEmpty)! && (passwrdParam.text?.count)! >= 8  ){
            
            //add back end verification here
            var email = emailParameter.text
            //get the substring before "@usc.edu"
            if (email?.contains("@usc.edu"))!{
                let endIndex = email?.index((email?.endIndex)!, offsetBy: -8)
                email = email?.substring(to: endIndex!)
            }
            var password = passwrdParam.text
            password = password?.sha256()
            ref.child("users").observeSingleEvent(of: .value, with: {(snapshot) in
                let dict = snapshot.value as? NSDictionary
                let user_info = dict?[email!] as? NSDictionary //Getting Current User's Info from the big Dictionary
                
                if (user_info != nil){
                    //comparing password
                    let db_password = user_info?["Password"] as? String ?? ""
                    if (password == db_password){
                        let firstName = user_info?["FirstName"] as? String ?? ""
                        globalVariable.currentUserFirstName = firstName
                        let lastName = user_info?["LastName"] as? String ?? ""
                        globalVariable.currentUserLastName = lastName

                        globalVariable.currentUserEmail = email!
                        self.performSegue(withIdentifier: "loginToFeed", sender: self)
                    }
                    else{
                        let alertController = UIAlertController(title: "Incorrect Password", message: "Password is incorrect.", preferredStyle: .alert)
                        
                        let action = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction) in
                            print("You've pressed cancel");
                        }
                        alertController.addAction(action)
                        
                        self.present(alertController, animated: true, completion: nil)

                    }
                }
                else{
                    let alertController = UIAlertController(title: "Incorrect Email", message: "Email not found.", preferredStyle: .alert)
                    
                    let action = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction) in
                        print("You've pressed cancel");
                    }
                    alertController.addAction(action)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            })
        }//end of backend verification
            
        else if (emailParameter.text?.isEmpty)! || !(emailParameter.text?.contains("@usc.edu"))! {
            
            let alertController = UIAlertController(title: "Incorrect Email", message: "Email must not be empty and a valid usc email.", preferredStyle: .alert)
            
            let action2 = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction) in
                print("You've pressed cancel");
            }
            alertController.addAction(action2)

            self.present(alertController, animated: true, completion: nil)        }
        else{
            
            let alertController = UIAlertController(title: "Incorrect Password", message: "Password must not be empty and over 8 characters", preferredStyle: .alert)
            
            let action2 = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction) in
                print("You've pressed cancel");
            }
            alertController.addAction(action2)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailParameter {
            passwrdParam.becomeFirstResponder()
        }
        else {
            verifyLogin(self)
        }
        return true
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailParameter.resignFirstResponder()
    }

}
