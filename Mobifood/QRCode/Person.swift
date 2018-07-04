//
//  Person.swift
//  Mobifood
//
//  Created by Duy Tuan on 7/2/18.
//  Copyright © 2018 Duy Tuan. All rights reserved.
//

import UIKit

class Person: NSObject, NSCoding {
    func encode(with aCoder: NSCoder) {
        if let name = name { aCoder.encode(name, forKey: "name") }
        if let age = age { aCoder.encode(age, forKey: "age") }
    }
    
    var name: String!
    var age: Int?
    
    required convenience init(coder decoder: NSCoder) {
        self.init()
        self.name = decoder.decodeObject(forKey: "name") as! String
        self.age = decoder.decodeInteger(forKey: "age")
    }
    
    convenience init(name: String, age: Int) {
        self.init()
        self.name = name
        self.age = age
    }
}
