//
//  SetAnimationController.swift
//  MyReader
//
//  Created by RN-079 on 2017/03/21.
//  Copyright © 2017年 RN-079. All rights reserved.
//

import UIKit

class SetAnimationController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    let model = SetAnimationModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setTableView() {
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension SetAnimationController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
}

extension SetAnimationController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.infos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let info = model.infos[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "SetAnimationCell", for: indexPath) as! SetAnimationCell
        
        cell.titleLbl.text = info.title
        
        var mode = UserDefaults.standard.integer(forKey: UDKey.AnimationMode)
        if (mode == 0) {
            mode = 1
        }
        
        if (mode == indexPath.row + 1) {
            cell.checkImgView.isHidden = false
            cell.titleLbl.textColor = UIColor.blue
        } else {
            cell.checkImgView.isHidden = true
            cell.titleLbl.textColor = UIColor.black
        }
        
        return cell
    }
}
