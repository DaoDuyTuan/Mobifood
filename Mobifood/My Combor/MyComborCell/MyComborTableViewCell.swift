//
//  MyComborTableViewCell.swift
//  Mobifood
//
//  Created by Duy Tuan on 6/8/18.
//  Copyright © 2018 Duy Tuan. All rights reserved.
//

import UIKit

class MyComborTableViewCell: UITableViewCell {

    @IBOutlet weak var myComborImage: UIImageView!
    @IBOutlet weak var lblComborName: UILabel!
    @IBOutlet weak var lblComborPrice: UILabel!
    @IBOutlet weak var lblPackageName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.layer.cornerRadius = 20.0
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor(displayP3Red: 184/255, green: 184/255, blue: 184/255, alpha: 184/255).cgColor
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = UIEdgeInsetsInsetRect(contentView.frame, UIEdgeInsetsMake(5, 5, 5, 5))
    }
}
