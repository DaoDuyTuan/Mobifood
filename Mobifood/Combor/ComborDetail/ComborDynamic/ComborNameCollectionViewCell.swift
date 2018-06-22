//
//  ComborNameCollectionViewCell.swift
//  Mobifood
//
//  Created by Duy Tuan on 6/7/18.
//  Copyright © 2018 Duy Tuan. All rights reserved.
//

import UIKit

class ComborNameCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lblComborName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.lblComborName.layer.cornerRadius = 5.0
        self.lblComborName.layer.masksToBounds = true
    }
}
