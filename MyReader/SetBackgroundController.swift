//
//  SetBackgroundController.swift
//  MyReader
//
//  Created by RN-079 on 2017/03/24.
//  Copyright © 2017年 RN-079. All rights reserved.
//

import UIKit

class SetBackgroundController: ViewController {
    @IBOutlet weak var effectView : UIView!
    @IBOutlet weak var tableView: UITableView!
    
    let model = ColorSetModel()

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
        model.setColorSets { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

extension SetBackgroundController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 16 + 40 + 16
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SetBackgroundController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.colorSets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let info = model.colorSets[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ColorSetCell", for: indexPath) as! ColorSetCell
        cell.colorView.backgroundColor = info.color
        cell.nameLbl.text = info.name
        
        return cell
    }
}
