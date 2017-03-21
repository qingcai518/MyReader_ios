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
        getData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setTableView() {
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func getData() {
        model.getInfos { [weak self] msg in
            if let errorMsg = msg {
                print("error = \(errorMsg)")
            }
            
            self?.tableView.reloadData()
        }
    }
}

extension SetAnimationController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        var value = "经典"
        if (indexPath.row == 1) {
            value = "左右"
        }
        
        UserDefaults.standard.set(value, forKey: UDKey.AnimationMode)
        UserDefaults.standard.synchronize()
        
        let _ = self.navigationController?.popViewController(animated: true)
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
        
        if let value = UserDefaults.standard.object(forKey: UDKey.AnimationMode) as? String {
            if (value == "经典") {
                cell.checkImgView.isHidden = false
                cell.titleLbl.textColor = UIColor.blue
            } else {
                cell.checkImgView.isHidden = true
                cell.titleLbl.textColor = UIColor.black
            }
        }
        
        return cell
    }
}
