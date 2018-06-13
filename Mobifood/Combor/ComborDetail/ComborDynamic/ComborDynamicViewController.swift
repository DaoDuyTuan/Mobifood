//
//  ComborDynamicViewController.swift
//  Mobifood
//
//  Created by Duy Tuan on 6/7/18.
//  Copyright © 2018 Duy Tuan. All rights reserved.
//

import UIKit

class ComborDynamicViewController: UIViewController {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var lblComborName: UILabel!
    @IBOutlet weak var listSelectedCombor: UITableView!
    @IBOutlet weak var listComborTableView: UITableView!
    @IBOutlet weak var btnExtends: UIButton!
    @IBOutlet weak var myView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "ComborDetailDynamicTableViewCell", bundle: nil)
        self.listComborTableView.register(nib, forCellReuseIdentifier: "comborTableCell")
        
        let nibCell = UINib(nibName: "ComborDetailCellTableViewCell", bundle: nil)
        self.listSelectedCombor.register(nibCell, forCellReuseIdentifier: "ComborDetailCell")
        
        Utils.setBorder(table: self.listComborTableView, width: 1, radius: 10.0, color: UIColor.myColor)
        Utils.setBorder(table: self.listSelectedCombor, width: 1, radius: 10.0, color: UIColor.myColor)
        self.btnExtends.layer.cornerRadius = 20.0
        self.btnExtends.layer.masksToBounds = true
    }
    
    @IBAction func extends(_ sender: Any) {
        
    }
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension ComborDynamicViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == listComborTableView {
            return 7
        }
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.listComborTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "comborTableCell", for: indexPath) as! ComborDetailDynamicTableViewCell
            cell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ComborDetailCell", for: indexPath) as! ComborDetailCellTableViewCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}
extension ComborDynamicViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "comborNameCell" , for: indexPath) as! ComborNameCollectionViewCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.listComborTableView.frame.width * 0.25, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

}

