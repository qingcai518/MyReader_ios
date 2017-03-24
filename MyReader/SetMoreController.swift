//
//  SetMoreController.swift
//  MyReader
//
//  Created by RN-079 on 2017/03/21.
//  Copyright © 2017年 RN-079. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SetMoreController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var closeBtn : UIButton!
    
    let model = SetMoreModel()
    let disposeBag = DisposeBag()
    
    @IBAction func doClose() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setRecieveNotification()
        setTableView()
        getData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setRecieveNotification() {
        NotificationCenter.default.rx.notification(Notification.Name(rawValue: NotificationName.ChangeMoreSet)).bindNext { [weak self] sender in
            self?.getData()
        }.addDisposableTo(disposeBag)
    }
    
    private func setTableView() {
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func getData() {
        model.getSetInfos { [weak self] msg in
            if let errorMsg = msg {
                print("error message = \(errorMsg)")
            }
            
            self?.tableView.reloadData()
        }
    }
}

extension SetMoreController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if (indexPath.section == 0) {
            
        } else if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                self.performSegue(withIdentifier: "ToSetAnimation", sender: nil)
            } else if (indexPath.row == 1) {
                self.performSegue(withIdentifier: "ToSetBackground", sender: nil)
            }
        }
    }
}

extension SetMoreController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return model.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.sections[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let info = model.sections[indexPath.section][indexPath.row]
        if (indexPath.section == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SetSwitchCell", for: indexPath) as! SetSwitchCell
            cell.titleLbl.text = info.title
            cell.switchBtn.isOn = UserDefaults.standard.bool(forKey: UDKey.IsSafeMode)
            return cell
        } else if (indexPath.section == 1) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SetRightCell", for: indexPath) as! SetRightCell
            cell.titleLbl.text = info.title
            cell.rightLbl.text = info.rightText
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SetCell", for: indexPath) as! SetCell
            cell.titleLbl.text = info.title
            return cell
        }
    }
}
