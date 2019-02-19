//
//  Profile.swift
//  Munch
//
//  Created by Sean Lissner on 27.11.18.
//

import Foundation

class Profile {
    var firstName: String
    var lastName: String
    var username: String
    var classification: String
    var profileInt: Int
    var numMunches: Int
    
    init(fName: String, lName: String, user: String, userClass: String, profile: Int, numMunch: Int){
        firstName = fName
        lastName = lName
        classification = userClass
        profileInt = profile
        numMunches = numMunch
        username = user
    }
}
