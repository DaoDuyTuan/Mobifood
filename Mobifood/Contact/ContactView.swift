//
//  ContactView.swift
//  Mobifood
//
//  Created by Duy Tuan on 6/6/18.
//  Copyright © 2018 Duy Tuan. All rights reserved.
//

import UIKit

class ContactView: UIView {

    @IBOutlet weak var myContact: UIView!
    
    @IBOutlet weak var myBg: UIView!
    override func awakeFromNib() {
        self.myContact.layer.cornerRadius = 5.0
    }
    @IBAction func call(_ sender: Any) {
        if let url = NSURL(string: "TEL://1234567890") {
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        Utils.setAnimation(view: self)
        Utils.animateOut(view: self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchs: UITouch? = touches.first
        if touchs?.view == self.myBg {
            Utils.animateOut(view: self)
        }
    }
}
