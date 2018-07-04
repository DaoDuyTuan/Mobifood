//
//  MyCombor.swift
//  Mobifood
//
//  Created by Duy Tuan on 6/26/18.
//  Copyright © 2018 Duy Tuan. All rights reserved.
//

import UIKit

struct MyCombor {
    var name: String?
    var idCombor: String?
    var price: String?
    var image: String?
    var items: [Product] = []
    var date: String?
    
    init(id: String, name: String, price: String, date: String, image: String) {
        self.idCombor = id
        self.name = name
        self.price = price
        self.date = date
        self.image = image
    }
    
    init() {
        
    }
}
