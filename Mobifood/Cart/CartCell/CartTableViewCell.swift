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
    @IBOutlet weak var lblEdit: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.layer.cornerRadius = 20.0
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor(displayP3Red: 184/255, green: 184/255, blue: 184/255, alpha: 184/255).cgColor
        
        self.itemImageView.layer.borderWidth = 1.0
        self.itemImageView.layer.borderColor = UIColor.black.cgColor
        
        self.isItemSelected.layer.cornerRadius = 5.0
        self.isItemSelected.layer.masksToBounds = false
        self.isItemSelected.clipsToBounds = true
        self.isItemSelected.layer.borderWidth = 1
        self.isItemSelected.layer.borderColor = UIColor.black.cgColor
        self.lblEdit.attributedText = self.attributedString(color: UIColor(displayP3Red: 253/255, green: 179/255, blue: 102/255, alpha: 1), string: "Sửa")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = UIEdgeInsetsInsetRect(contentView.frame, UIEdgeInsetsMake(3, 3, 3, 3))
    }
    @IBAction func selectItem(_ sender: UIButton) {
        if !CartViewController.cart[sender.tag].isCheckedProduct {
            UIView.animate(withDuration: 0.5, animations: {
                sender.backgroundColor = UIColor.myGreen
                sender.setTitle("✓", for: .normal)
                sender.setTitleColor(UIColor.red, for: .normal)
            })
            CartViewController.cart[sender.tag].isChecked = true
        } else {
            UIView.animate(withDuration: 0.5, animations: {            
                sender.backgroundColor = UIColor.white
                sender.setTitle("", for: .normal)
            })
            CartViewController.cart[sender.tag].isChecked = false
        }
        self.delegate.chooseProduct(index: sender.tag, isChecked: isChecked)
    }
    private func attributedString(color: UIColor, string: String) -> NSAttributedString? {
        let attributes : [NSAttributedStringKey : Any] = [
            NSAttributedStringKey.foregroundColor : color,
            NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue
        ]
        let attributedString = NSAttributedString(string: string, attributes: attributes)
        return attributedString
    }
}
