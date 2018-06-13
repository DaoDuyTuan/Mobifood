//
//  ServiceApi.swift
//  Mobifood
//
//  Created by Duy Tuan on 6/8/18.
//  Copyright © 2018 Duy Tuan. All rights reserved.
//

import Foundation

struct ProductList: Codable {
    var products: [Product] = []
    
    enum CodingProduct: String, CodingKey {
        case products
    }
}
