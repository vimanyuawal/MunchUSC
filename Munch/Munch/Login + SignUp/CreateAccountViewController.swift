//
//  NewProfileViewController.swift
//  Munch
//
//  Created by Sean Lissner on 12.11.18.
//

import UIKit
import Firebase


class CreateAccountViewController: UIViewController, UITextFieldDelegate {
    
//    struct globalVariable{
//        static var currentUserEmail = "";
//    }

    @IBOutlet weak var fname: UITextField!
    @IBOutlet weak var lname: UITextField!
    @IBOutlet weak var passToConfirm: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet var btnCreateAccount: UIButton!
    @IBOutlet var viewPickerSuperView: UIView!
    @IBOutlet var btnSelClassification: UIButton!
    @IBOutlet var lblClassification: UILabel!
    @IBOutlet var pvClassification: UIPickerView!
    let classifications = ["No Selection", "Freshman", "Sophomore", "Junior", "Senior"]
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fname.becomeFirstResponder()
        btnSelClassification.layer.cornerRadius = btnSelClassification.layer.bounds.height/2
        lblClassification.layer.cornerRadius = 10
        btnCreateAccount.layer.cornerRadius = btnCreateAccount.layer.bounds.height/2
        lblClassification.text = "No Selection"

        ref = Database.database().reference()
    }
    
    
    @IBAction func createAccount(_ sender: Any) {
        if((fname.text?.isEmpty)! || (lname.text?.isEmpty)!){
            let alertController = UIAlertController(title: "Error", message: "Please input a first and last name.", preferredStyle: .alert)
            
            let action2 = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction) in
                print("You've pressed cancel");
            }
            alertController.addAction(action2)
            
            self.present(alertController, animated: true, completion: nil)        }
        
        else if((email.text?.isEmpty)! || !(email.text?.contains("@usc.edu"))!){
            let alertController = UIAlertController(title: "Error", message: "Please enter a valid USC email.", preferredStyle: .alert)
            
            let action2 = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction) in
                print("You've pressed cancel");
            }
            alertController.addAction(action2)
            
            self.present(alertController, animated: true, completion: nil)        }
        
        else if((password.text?.count)! < 8){
            let alertController = UIAlertController(title: "Error", message: "Password must be at least 8 characters long", preferredStyle: .alert)
            
            let action2 = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction) in
                print("You've pressed cancel");
            }
            alertController.addAction(action2)
            
            self.present(alertController, animated: true, completion: nil)        }
        
        else if(password.text != passToConfirm.text){
            let alertController = UIAlertController(title: "Error", message: "Passwords do not match!", preferredStyle: .alert)
            
            let action2 = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction) in
                print("You've pressed cancel");
            }
            alertController.addAction(action2)
            
            self.present(alertController, animated: true, completion: nil)
        }
        else {
            let fname = self.fname.text
            let lname = self.lname.text
            var email = self.email.text!
            var password = self.password.text
            password = password?.sha256()
            //get the substring before "@usc.edu"
            if (email.contains("@usc.edu")){
                let endIndex = email.index((email.endIndex), offsetBy: -8)
                email = email.substring(to: endIndex)
            }
            LoginViewController.globalVariable.currentUserEmail = email;
            LoginViewController.globalVariable.currentUserFirstName = fname!;
            LoginViewController.globalVariable.currentUserLastName = lname!;
            let randomInt = Int.random(in: 0..<7)
            let user = ["FirstName" : fname!,
                        "LastName" : lname!,
                        "Password" : password!,
                "Classification" : lblClassification.text!,
                "NumOfMunches" : 0,
                "Avatar" : randomInt] as [String : Any]
            self.ref.updateChildValues(["/users/\(email)": user,
                                        "/followers/\(email)/\(email)" : true])
            //if backend shit works then send to other page
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func presentPicker(_ sender: Any) {
        pvClassification.selectRow(findClassificationRow(), inComponent: 0, animated: false)
        presentPicker()
    }
    
    @IBAction func dismissPicker(_ sender: Any) {
        dismissPicker()
        password.becomeFirstResponder()
    }
    
    func findClassificationRow() -> Int {
        if lblClassification.text == "No Selection" {
            return 0
        }
        else {
            return classifications.index(of: lblClassification.text!)!
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == fname {
            lname.becomeFirstResponder()
        }
        else if textField == lname {
            email.becomeFirstResponder()
        }
        else if textField == email {
            email.resignFirstResponder()
            presentPicker()
        }
        else if textField == password {
            passToConfirm.becomeFirstResponder()
        }
        else {
            createAccount(self)
        }
        return true
    }

    @IBAction func backToLanding(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension CreateAccountViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 5
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return classifications[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        lblClassification.text = classifications[row]
    }
    
    
}
