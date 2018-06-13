//
//  menuTableViewCell.swift
//  Mobifood
//
//  Created by Duy Tuan on 6/5/18.
//  Copyright © 2018 Duy Tuan. All rights reserved.
//

import UIKit

class menuTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageMenu: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
