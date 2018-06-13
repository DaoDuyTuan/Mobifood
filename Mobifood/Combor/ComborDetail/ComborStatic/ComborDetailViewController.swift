//
//  ComborDetailViewController.swift
//  Mobifood
//
//  Created by Duy Tuan on 6/7/18.
//  Copyright © 2018 Duy Tuan. All rights reserved.
//

import UIKit

class ComborDetailViewController: UIViewController {

    @IBOutlet weak var btlExtends: UIButton!
    @IBOutlet weak var comborImage: UIImageView!
    @IBOutlet weak var lblComborName: UILabel!
    @IBOutlet weak var comborTypeTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btlExtends.layer.cornerRadius = 15.0
        let nibCell = UINib(nibName: "ComborDetailCellTableViewCell", bundle: nil)
        self.comborTypeTableView.register(nibCell, forCellReuseIdentifier: "ComborDetailCell")
    }
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension ComborDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ComborDetailCell", for: indexPath) as! ComborDetailCellTableViewCell
        return cell
    }
}
