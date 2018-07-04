//
//  MyComborTableViewCell.swift
//  Mobifood
//
//  Created by Duy Tuan on 6/8/18.
//  Copyright © 2018 Duy Tuan. All rights reserved.
//

import UIKit
import Foundation

protocol ComborState: class {
    func buy(index: Int)
    func remove(index: Int)
}

class MyComborTableViewCell: UITableViewCell {
    
    var delegate: ComborState!
    
    @IBOutlet weak var btnBook: UIButton!
    @IBOutlet weak var myComborImage: UIImageView!
    @IBOutlet weak var lblComborName: UILabel!
    @IBOutlet weak var lblComborPrice: UILabel!
    @IBOutlet weak var lblPackageName: UILabel!
    @IBOutlet weak var btnRemove: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.btnBook.setAttributedTitle(self.attributedString(color: UIColor.myGreen, string: "Mua"), for: .normal)
        self.btnRemove.setAttributedTitle(self.attributedString(color: UIColor.red, string: "Xoá"), for: .normal)
        self.contentView.layer.cornerRadius = 20.0
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor(displayP3Red: 184/255, green: 184/255, blue: 184/255, alpha: 184/255).cgColor
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = UIEdgeInsetsInsetRect(contentView.frame, UIEdgeInsetsMake(5, 5, 5, 5))
    }
    
    @IBAction func bookCombor(_ sender: UIButton) {
        self.delegate.buy(index: sender.tag)
    }
    
    @IBAction func remove(_ sender: UIButton) {
        self.delegate.remove(index: sender.tag)
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
