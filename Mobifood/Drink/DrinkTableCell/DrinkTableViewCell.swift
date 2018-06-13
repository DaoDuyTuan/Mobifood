//
//  DrinkTableViewCell.swift
//  Mobifood
//
//  Created by Duy Tuan on 6/6/18.
//  Copyright © 2018 Duy Tuan. All rights reserved.
//

import UIKit

class DrinkTableViewCell: UITableViewCell {

    @IBOutlet weak var DrinkCollectionView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        let nibTableViewCell1 = UINib(nibName: "DrinkCollectionViewCell", bundle: nil)
        self.DrinkCollectionView.register(nibTableViewCell1, forCellWithReuseIdentifier: "drinkCollectionCell")
    }
}
extension DrinkTableViewCell {
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate: D, forRow row: Int) {
        DrinkCollectionView.delegate = dataSourceDelegate
        DrinkCollectionView.dataSource = dataSourceDelegate
        DrinkCollectionView.tag = row
        DrinkCollectionView.setContentOffset(DrinkCollectionView.contentOffset, animated:false) // Stops collection view if it was scrolling.
        DrinkCollectionView.reloadData()
    }
    
    var collectionViewOffset: CGFloat {
        set { DrinkCollectionView.contentOffset.x = newValue }
        get { return DrinkCollectionView.contentOffset.x }
    }
}
