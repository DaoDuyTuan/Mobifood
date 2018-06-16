//
//  MenuViewController.swift
//  Mobifood
//
//  Created by Duy Tuan on 6/5/18.
//  Copyright © 2018 Duy Tuan. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
import BarcodeScanner

class MenuViewController: UIViewController {

    @IBOutlet weak var menuTableView: UITableView!
    let images = ["ic_mycombor", "ic_policy", "ic_qr", "ic_settings", "ic_aboutus"]
    let labels = ["My Combor", "Policy", "QR Code", "Setting", "About us"]
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "menuTableViewCell", bundle: nil)
        self.menuTableView.register(nib, forCellReuseIdentifier: "menuCell")
    }
}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as! menuTableViewCell
        cell.imageMenu.image = UIImage(named: images[indexPath.row])
        cell.titleLabel.text = labels[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        HomeViewController.index = indexPath.row
        switch indexPath.row {
        case 0:
            let vcSetting = MyComborViewController(nibName: "MyComborViewController", bundle: nil)
            Utils.setAnimation(view: self.view)
            self.navigationController?.pushViewController(vcSetting, animated: true)
        case 1:
            print(indexPath.row)
        case 2:
            let barcodeVC = BarcodeScannerViewController()
            
            barcodeVC.codeDelegate = self
            barcodeVC.errorDelegate = self
            barcodeVC.dismissalDelegate = self
            self.present(barcodeVC, animated: true, completion: nil)
        case 3:
            let vcSetting = SettingViewController(nibName: "SettingViewController", bundle: nil)
            Utils.setAnimation(view: self.view)
            self.navigationController?.pushViewController(vcSetting, animated: true)
        case 4:
            let vc = AboutUsViewController(nibName: "AboutUsViewController", bundle: nil)
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            print("default")
        }
        slideMenuController()?.closeLeft()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 0.15 * UIScreen.main.bounds.height
    }
}
extension MenuViewController: BarcodeScannerCodeDelegate, BarcodeScannerErrorDelegate, BarcodeScannerDismissalDelegate {
    func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
        controller.dismiss(animated: true, completion: nil)
        print(code)
    }
    
    func scanner(_ controller: BarcodeScannerViewController, didReceiveError error: Error) {
        controller.dismiss(animated: true, completion: nil)
        Utils.warning(title: "Thông báo lỗi", message: "Invalid", addActionOk: true, addActionCancel: false)
    }
    
    func scannerDidDismiss(_ controller: BarcodeScannerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
