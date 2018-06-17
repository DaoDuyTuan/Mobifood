//
//  HomeViewController.swift
//  Mobifood
//
//  Created by Duy Tuan on 6/4/18.
//  Copyright © 2018 Duy Tuan. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SlideMenuControllerSwift
import Alamofire
import SystemConfiguration

class HomeViewController: ButtonBarPagerTabStripViewController {

    static var index: Int = 0
    
    @IBOutlet weak var titleScreen: UILabel!
    @IBOutlet weak var menuBar: ButtonBarView!
    @IBOutlet weak var headerHome: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // when select tab
        NetworkManager.whenNoConnection()
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            
            switch self.settings.style.myIndex {
            case 0:
                self.titleScreen.text = "COMBOR"
            case 1:
                self.titleScreen.text = "ĐỒ UỐNG"
            case 2:
                self.titleScreen.text = "TRÁI CÂY"
            case 3:
                self.titleScreen.text = "BẢN ĐỒ"
            default:
                print("afdasdf")
            }
            oldCell?.label.textColor = UIColor(white: 1, alpha: 0.6)
            newCell?.label.textColor = .white
            
            if animated {
                UIView.animate(withDuration: 0.1, animations: { () -> Void in
                    newCell?.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                    oldCell?.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                })
            }
            else {
                newCell?.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                oldCell?.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }
        }
    }
    
    @IBAction func viewMenu(_ sender: Any) {
        slideMenuController()?.openLeft()
        slideMenuController()?.delegate = self
    }
    
    @IBAction func viewCart(_ sender: Any) {
        let cartVC = CartViewController(nibName: "CartViewController", bundle: nil)
        self.navigationController?.pushViewController(cartVC, animated: true)
    }
    
    override func updateIndicator(for viewController: PagerTabStripViewController, fromIndex: Int, toIndex: Int) {
        print(toIndex)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func viewDidLayoutSubviews() {
        self.setHeader(view: menuBar)
        self.setHeader(view: headerHome)
    }
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let combor = ComborViewController(nibName: "ComborViewController", bundle: nil)
        let drink = DrinkViewController(nibName: "DrinkViewController", bundle: nil)
        let fruit = FruitViewController(nibName: "FruitViewController", bundle: nil)
        let map = MapViewController(nibName: "MapViewController", bundle: nil)
        
        return [combor, drink, fruit, map]
    }
    
    override func viewWillLayoutSubviews() {
        settings.style.selectedBarBackgroundColor = UIColor(displayP3Red: 30/255, green: 181/255, blue: 228/255, alpha: 1)
    }
    @IBAction func call(_ sender: Any) {
        let viewNib = Bundle.main.loadNibNamed("ContactView", owner: self, options: nil)?[0] as! ContactView
        viewNib.frame = (UIApplication.shared.delegate?.window??.bounds)!
        Utils.animateIn(view: viewNib)
        UIApplication.shared.delegate?.window??.addSubview(viewNib)
    }
}

extension HomeViewController {
    func setHeader(view: UIView) {
        // custom header color background
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [UIColor(displayP3Red: 0/255, green: 174/255, blue: 236/255, alpha: 1).cgColor, UIColor(displayP3Red: 3/255, green: 166/255, blue: 131/255, alpha: 1).cgColor]
        view.layer.insertSublayer(gradient, at: 0)
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
    }
}

extension HomeViewController: SlideMenuControllerDelegate {
    func leftDidClose() {
//        self.moveToViewController(at: HomeViewController.index, animated: true)
    }
}
