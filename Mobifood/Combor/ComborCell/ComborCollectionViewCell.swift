//
//  ComborCollectionViewCell.swift
//  Mobifood
//
//  Created by Duy Tuan on 6/5/18.
//  Copyright © 2018 Duy Tuan. All rights reserved.
//

import UIKit

class ComborCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var comborImageView: UIImageView!
    @IBOutlet weak var btnBuyItem: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.comborImageView.layer.cornerRadius = 5
        self.comborImageView.layer.masksToBounds = true
        self.btnBuyItem.layer.cornerRadius = 15.0
    }

    @IBAction func buyiTEM(_ sender: UIButton) {
        
    }
}
