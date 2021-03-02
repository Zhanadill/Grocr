//
//  User.swift
//  Grocr
//
//  Created by Жанадил on 3/1/21.
//  Copyright © 2021 Жанадил. All rights reserved.
//

import Foundation
import Firebase

/*struct User{
    let uid: String
    let email: String
}*/
struct User{
    let ref: DatabaseReference?
    let uid:String
    let email:String

    init(uid: String, email: String) {
        self.ref = nil
        self.uid = uid
        self.email = email
    }

    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let uid = value["uid"] as? String,
            let email = value["email"] as? String
        else {
            return nil
        }

        self.ref = snapshot.ref as DatabaseReference
        self.uid = uid
        self.email = email
    }

    func toAnyObject() -> Any {
        return [
            "uid": self.uid,
            "email": self.email
        ]
    }
}
