//
//  ComborDetailViewController.swift
//  Mobifood
//
//  Created by Duy Tuan on 6/7/18.
//  Copyright © 2018 Duy Tuan. All rights reserved.
//

import UIKit

class ComborDetailViewController: UIViewController {

    @IBOutlet weak var heightContainerScroll: NSLayoutConstraint!
    @IBOutlet weak var btlExtends: UIButton!
    @IBOutlet weak var comborImage: UIImageView!
    @IBOutlet weak var lblComborName: UILabel!
    @IBOutlet weak var comborTypeTableView: UITableView!
    
    var comborDetail: MyCombor!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btlExtends.layer.cornerRadius = 15.0
        Utils.setBorder(table: self.comborTypeTableView, width: 1, radius: 10.0, color: UIColor.myColor)
        
        let nibCell = UINib(nibName: "ComborDetailCellTableViewCell", bundle: nil)
        self.comborTypeTableView.register(nibCell, forCellReuseIdentifier: "ComborDetailCell")
        
        self.updateUI()
    }
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        self.autoLayoutUI()
    }
    @IBAction func buyCombor(_ sender: Any) {
        let vc = CustormerViewController(nibName: "CustormerViewController", bundle: nil)
        self.present(vc, animated: true, completion: nil)
    }
    
    private func autoLayoutUI() {
        let heightScreen = UIScreen.main.bounds.height
        if heightScreen > 1300 {
            self.heightContainerScroll.constant = 1500
        } else if heightScreen > 1000 && heightScreen < 1300 {
            self.heightContainerScroll.constant = 1300
        } else if heightScreen < 667 {
            self.heightContainerScroll.constant = 700
        } else if heightScreen > 667 && heightScreen < 1000 {
            self.heightContainerScroll.constant = 772
        }
    }
    
    private func updateUI() {
        self.comborImage.sd_setImage(with: URL(string: comborDetail.image ?? "loading"))
        self.lblComborName.text = self.comborDetail.name
    }
}

extension ComborDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.comborDetail.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ComborDetailCell", for: indexPath) as! ComborDetailCellTableViewCell
        let item = self.comborDetail.items[indexPath.row]
        cell.btnDelete.isHidden = true
        cell.btnHeightDeleteConstraint.constant = -(cell.btnDelete.frame.width)
        cell.spaceOfBtnDeleteAndName.constant = 0
        cell.lblComborType.text = "Drink \(indexPath.row + 1)"
        cell.lblComborName.text = item.productTitle
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 0.18 * tableView.frame.height
    }
}
