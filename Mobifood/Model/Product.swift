//
//  Product.swift
//  Mobifood
//
//  Created by Duy Tuan on 6/8/18.
//  Copyright © 2018 Duy Tuan. All rights reserved.
//

import UIKit

struct Image: Codable {
    var src: String = ""
    
    enum CodingKeys: String, CodingKey {
        case src
    }
}
struct Variant: Codable {
    var price: Int
    init(price: Int) {
        self.price = price
    }
    enum CodingVariant: String, CodingKey {
        case price
    }
}
struct Product: Codable {
    private var id: Double?
    private var title: String?
    private var variants: [Variant]?
    private var images: [Image]?
    var amount: Int?
    var isChecked: Bool?    
    var isCheckedProduct: Bool {
        get {
            if let check = self.isChecked {
                return check
            }
            return false
        }
    }
    
    init(id: Double, title: String, variants: [Variant], images: [Image], amount: Int, isChecked: Bool) {
        self.id = id
        self.title = title
        self.variants = variants
        self.images = images
        self.amount = amount
        self.isChecked = isChecked
    }
    
    init() {
        
    }
    
    var productID: Double? {
        get {
            return id ?? nil
        }
    }
    
    var productTitle: String {
        get {
            return self.title != nil ? self.title! : "Updating"
        }
    }
    
    var productVariants: Variant {
        get {
            return self.variants != nil ? self.variants![0] : Variant(price: 0)
        }
        set(value) {
            self.variants = [value]
        }

    }
    
    var productPrice: (isNumber: Int, isString: String) {
        get {            
            return (self.productVariants.price, Utils.formmatCurrentcy(fommater: "", price: self.productVariants.price as NSNumber))
        }
    }
    
    var productImage: [Image] {
        get {
            if let image = self.images {
                return image
            }
            return []
        }
    }
    
    enum CodingProduct: String, CodingKey {
        case title
        case images
        case variants
        case id
    }
}
