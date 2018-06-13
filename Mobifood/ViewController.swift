//
//  ViewController.swift
//  Mobifood
//
//  Created by Duy Tuan on 6/4/18.
//  Copyright © 2018 Duy Tuan. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
import Alamofire

class ViewController: SlideMenuController {
    override func awakeFromNib() {
        self.mainViewController = HomeViewController(nibName: "HomeViewController", bundle: nil)
        self.leftViewController = MenuViewController(nibName: "MenuViewController", bundle: nil)
        super.awakeFromNib()
    }
    
    override func viewDidLoad() {
        
    }
}
