//
//  DrinkDetailView.swift
//  Mobifood
//
//  Created by Duy Tuan on 6/6/18.
//  Copyright © 2018 Duy Tuan. All rights reserved.
//

import UIKit
import SDWebImage

class DrinkDetailView: UIView {
    @IBOutlet weak var fruitImageView: UIImageView!
    @IBOutlet weak var numberPickerView: UIPickerView!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblFruitName: UILabel!
    
    var price: String = "" {
        didSet {
            self.lblPrice.text = price
        }
    }
    
    var fruitImage: String = "" {
        didSet {
            self.fruitImageView.sd_setImage(with: URL(string: self.fruitImage), placeholderImage: UIImage(named: "red3"))
        }
    }
    
    var fruitName: String = "" {
        didSet {
            self.lblFruitName.text = fruitName
        }
    }
    override func awakeFromNib() {
        self.numberPickerView.transform = CGAffineTransform(rotationAngle: 90 * (.pi/180))
        self.layer.cornerRadius = 5.0
    }
    @IBAction func cancel(_ sender: Any) {
        Utils.animateOut(view: self)
    }
    
    @IBAction func addToCard(_ sender: Any) {
        Utils.animateOut(view: self)
    }
    
}
