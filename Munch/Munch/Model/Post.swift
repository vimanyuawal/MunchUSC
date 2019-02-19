
//
//  Post.swift
//  Munch
//
//  Created by Sean Lissner on 25.11.18.
//

import Foundation
import Firebase

class Post {
    var body: String
    var author: String
    var score: Int
    var diningHall: String
    var authorUsername: String
    
    init(bodyText: String, authorUser: String, authorText: String, scoreNum: Int, diningHallName: String) {
        body = bodyText
        author = authorText
        score = scoreNum
        diningHall = diningHallName
        authorUsername = authorUser
    }
}

extension Post : Equatable {
    static func == (lhs: Post, rhs: Post) -> Bool {
        let boolbody = lhs.body == rhs.body
        let boolauthor = lhs.author == rhs.author
        let boolscore = lhs.score == rhs.score
        let booldining = lhs.diningHall == rhs.diningHall

        return boolbody && boolauthor && boolscore && booldining
    }
}
