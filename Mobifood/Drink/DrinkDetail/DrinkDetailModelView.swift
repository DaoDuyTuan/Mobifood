//
//  DrinkDetailModelView.swift
//  Mobifood
//
//  Created by Duy Tuan on 7/7/18.
//  Copyright © 2018 Duy Tuan. All rights reserved.
//

import UIKit

class DrinkDetailModelView: NSObject {
    static var drinkDetailModelView = DrinkDetailModelView()
    
    func setDataForDrinkDetail(vc: DrinkDetailViewController, with drink: Product) {
        vc.fruitImage = drink.productImage.count > 0 ? drink.productImage[0].src : "notimage"
        vc.fruitName = drink.productTitle
        vc.price = "\(Utils.formmatCurrentcy(fommater: "", price: drink.productVariants.price as NSNumber) )"
    }
    
    func setViewWillShow(vc: DrinkDetailViewController) {
        vc.modalPresentationStyle = .overCurrentContext
        vc.view.backgroundColor = UIColor.clear
    }
}
