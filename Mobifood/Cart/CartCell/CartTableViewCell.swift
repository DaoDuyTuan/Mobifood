//
//  CartTableViewCell.swift
//  Mobifood
//
//  Created by Duy Tuan on 6/6/18.
//  Copyright © 2018 Duy Tuan. All rights reserved.
//

import UIKit

protocol ChooseProduct: class {
    func chooseProduct(index: Int, isChecked: Bool)
}

class CartTableViewCell: UITableViewCell {

    var isChecked: Bool = true
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblSize: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var isItemSelected: UIButton!
    weak var delegate: ChooseProduct!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.layer.cornerRadius = 20.0
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor(displayP3Red: 184/255, green: 184/255, blue: 184/255, alpha: 184/255).cgColor
        self.isItemSelected.layer.cornerRadius = self.isItemSelected.frame.width / 2
        self.isItemSelected.layer.masksToBounds = false
        self.isItemSelected.clipsToBounds = true
        self.isItemSelected.layer.borderWidth = 1
        self.isItemSelected.layer.borderColor = UIColor.black.cgColor
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = UIEdgeInsetsInsetRect(contentView.frame, UIEdgeInsetsMake(5, 5, 5, 5))
    }
    @IBAction func selectItem(_ sender: UIButton) {
        if !CartViewController.cart[sender.tag].isCheckedProduct {
            sender.backgroundColor = UIColor.myGreen
            sender.setTitle("✓", for: .normal)
            sender.setTitleColor(UIColor.red, for: .normal)
            CartViewController.cart[sender.tag].isChecked = true
        } else {
            sender.backgroundColor = UIColor.white
            sender.setTitle("", for: .normal)
            CartViewController.cart[sender.tag].isChecked = false
        }
        self.delegate.chooseProduct(index: sender.tag, isChecked: isChecked)
    }
}
