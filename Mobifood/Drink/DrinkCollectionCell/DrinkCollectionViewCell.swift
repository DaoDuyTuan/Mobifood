//
//  DrinkCollectionViewCell.swift
//  Mobifood
//
//  Created by Duy Tuan on 6/6/18.
//  Copyright © 2018 Duy Tuan. All rights reserved.
//

import UIKit

class DrinkCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lblSizeFruit: UILabel!
    @IBOutlet weak var lblNameFruit: UILabel!
    @IBOutlet weak var lblPriceFruit: UILabel!
    @IBOutlet weak var imageFruitImageView: UIImageView!
    @IBOutlet weak var lblSize: UILabel!
    @IBOutlet weak var lblSizeType: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor(displayP3Red: 184/255, green: 184/255, blue: 184/255, alpha: 184/255).cgColor
        self.layer.cornerRadius = 5.0
    }

}
