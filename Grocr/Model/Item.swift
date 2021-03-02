//
//  Item.swift
//  Grocr
//
//  Created by Жанадил on 2/28/21.
//  Copyright © 2021 Жанадил. All rights reserved.
//

import Foundation
import Firebase

struct Item{
    let ref: DatabaseReference?
    let text:String
    let author:String
    var completed:Bool

    init(text: String, author: String, completed: Bool) {
        self.ref = nil
        self.text = text
        self.author = author
        self.completed = completed
    }

    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let text = value["text"] as? String,
            let author = value["author"] as? String,
            let completed = value["completed"] as? Bool
        else {
            return nil
        }

        self.ref = snapshot.ref as DatabaseReference
        self.text = text
        self.author = author
        self.completed = completed
    }

    func toAnyObject() -> Any {
        return [
            "text": self.text,
            "author": self.author,
            "completed": self.completed
        ]
    }
}
