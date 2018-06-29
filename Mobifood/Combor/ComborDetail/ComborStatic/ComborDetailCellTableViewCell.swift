//
//  ComborDetailCellTableViewCell.swift
//  Mobifood
//
//  Created by Duy Tuan on 6/7/18.
//  Copyright © 2018 Duy Tuan. All rights reserved.
//

import UIKit

protocol DeleteDrinkInCombor: class {
    func deleteDrink(index: Int)
}

class ComborDetailCellTableViewCell: UITableViewCell {

    @IBOutlet weak var spaceOfBtnDeleteAndName: NSLayoutConstraint!
    @IBOutlet weak var btnHeightDeleteConstraint: NSLayoutConstraint!
    weak var delegate: DeleteDrinkInCombor!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var lblComborType: UILabel!
    @IBOutlet weak var lblComborName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.lblComborName.layer.cornerRadius = 5.0
        self.lblComborName.layer.masksToBounds = true
        self.lblComborName.layer.borderWidth = 3.0
        self.lblComborName.layer.borderColor = UIColor(displayP3Red: 1, green: 175/255, blue: 38/255, alpha: 1).cgColor
        
        self.btnDelete.layer.cornerRadius = self.btnDelete.frame.width/2
        self.btnDelete.layer.masksToBounds  = true
    }
    
    @IBAction func deleteItem(_ sender: UIButton) {
        self.delegate.deleteDrink(index: sender.tag)
    }
}
