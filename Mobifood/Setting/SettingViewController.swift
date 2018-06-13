//
//  SettingViewController.swift
//  Mobifood
//
//  Created by Duy Tuan on 6/8/18.
//  Copyright © 2018 Duy Tuan. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var settingView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingView.layer.borderWidth = 1.0
        settingView.layer.borderColor = UIColor.myColor.cgColor
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        Utils.setHeader(view: self.headerView)
    }
    @IBAction func onNitification(_ sender: UISwitch) {
        if sender.isOn {
            print("on")
        } else {
            print("off")
        }
    }
}
