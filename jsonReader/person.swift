//
//  person.swift
//  jsonReader
//
//  Created by ta on 9/25/17.
//  Copyright © 2017 Kartheek Chintalapati. All rights reserved.
//

import UIKit

class person: NSObject {
    var name: String!
    var profession: String!
    var dob: String!
    var children: [String]!
    
    init(name: String, profession: String, dob: String, children: [String])
    {
        self.name = name
        self.profession = profession
        self.dob = dob
        self.children = children
    }

}
