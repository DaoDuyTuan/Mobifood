//
//  ComborDynamicViewController.swift
//  Mobifood
//
//  Created by Duy Tuan on 6/7/18.
//  Copyright © 2018 Duy Tuan. All rights reserved.
//

import UIKit

class ComborDynamicViewController: UIViewController {

    @IBOutlet weak var listComborCollectionView: UICollectionView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var lblComborName: UILabel!
    @IBOutlet weak var listSelectedCombor: UITableView!
    @IBOutlet weak var btnExtends: UIButton!
    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var myViewConstrainHeight: NSLayoutConstraint!
    var combor: Product!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.settingUI()
    }

    override func viewDidLayoutSubviews() {
        let heightScreen = UIScreen.main.bounds.height
        if heightScreen > 1000 {
            self.myViewConstrainHeight.constant = 1700
        }
        
        if heightScreen < 667 {
            self.myViewConstrainHeight.constant = 850
        }
    }
    @IBAction func extends(_ sender: Any) {
        
    }
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension ComborDynamicViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ComborDetailCell", for: indexPath) as! ComborDetailCellTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 0.16 * tableView.frame.height
    }
}
extension ComborDynamicViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 32
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "comborNameCell" , for: indexPath) as! ComborNameCollectionViewCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width * 0.25)
        return CGSize(width: width, height: collectionView.frame.height * 0.2)
    }

}

extension ComborDynamicViewController {
    func updateCombor() {
        
    }
    
    func settingUI() {
        let nibCell = UINib(nibName: "ComborDetailCellTableViewCell", bundle: nil)
        self.listSelectedCombor.register(nibCell, forCellReuseIdentifier: "ComborDetailCell")
        
        let nibCombor = UINib(nibName: "ComborNameCollectionViewCell", bundle: nil)
        self.listComborCollectionView.register(nibCombor, forCellWithReuseIdentifier: "comborNameCell")
        
        Utils.setBorder(table: self.listSelectedCombor, width: 1, radius: 10.0, color: UIColor.myColor)
        self.btnExtends.layer.cornerRadius = 20.0
        self.btnExtends.layer.masksToBounds = true

    }
}

