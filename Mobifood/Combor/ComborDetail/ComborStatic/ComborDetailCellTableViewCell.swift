//
//  ComborDetailCellTableViewCell.swift
//  Mobifood
//
//  Created by Duy Tuan on 6/7/18.
//  Copyright © 2018 Duy Tuan. All rights reserved.
//

import UIKit

class ComborDetailCellTableViewCell: UITableViewCell {

    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var lblComborType: UILabel!
    @IBOutlet weak var lblComborName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.lblComborName.layer.cornerRadius = 5.0
        self.lblComborName.layer.masksToBounds = true
        
        self.btnDelete.layer.cornerRadius = self.btnDelete.frame.width/2
        self.btnDelete.layer.masksToBounds  = true
    }
    
}
