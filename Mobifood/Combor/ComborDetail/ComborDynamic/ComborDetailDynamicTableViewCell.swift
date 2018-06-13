//
//  ComborDetailDynamicTableViewCell.swift
//  Mobifood
//
//  Created by Duy Tuan on 6/7/18.
//  Copyright © 2018 Duy Tuan. All rights reserved.
//

import UIKit

class ComborDetailDynamicTableViewCell: UITableViewCell {

    @IBOutlet weak var listComborCollectionView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        let nibTableViewCell1 = UINib(nibName: "ComborNameCollectionViewCell", bundle: nil)
        self.listComborCollectionView.register(nibTableViewCell1, forCellWithReuseIdentifier: "comborNameCell")
    }
    
}
extension ComborDetailDynamicTableViewCell {
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate: D, forRow row: Int) {
        listComborCollectionView.delegate = dataSourceDelegate
        listComborCollectionView.dataSource = dataSourceDelegate
        listComborCollectionView.tag = row
        listComborCollectionView.setContentOffset(listComborCollectionView.contentOffset, animated:false) // Stops collection view if it was scrolling.
        listComborCollectionView.reloadData()
    }
}
