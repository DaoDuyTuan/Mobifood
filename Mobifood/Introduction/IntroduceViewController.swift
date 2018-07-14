//
//  IntroduceViewController.swift
//  Mobifood
//
//  Created by Duy Tuan on 6/4/18.
//  Copyright © 2018 Duy Tuan. All rights reserved.
//

import UIKit
import ImageSlideshow
import XLPagerTabStrip
import SlideMenuControllerSwift
import Reachability

class IntroduceViewController: UIViewController {
    
    @IBOutlet weak var introImageSlide: ImageSlideshow!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        introImageSlide.scrollView.alwaysBounceHorizontal = true
        introImageSlide.scrollView.bounces = false
        
        introImageSlide.setImageInputs([
            ImageSource(image: UIImage(named: "green1")!),
            ImageSource(image: UIImage(named: "red2")!),
            ImageSource(image: UIImage(named: "tim3")!),
            ImageSource(image: UIImage(named: "blue4")!)
            ])
        introImageSlide.circular = false
        NetworkManager.whenNoConnection()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @IBAction func directHome(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "root")
        Utils.setAnimation(view: self.view)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
