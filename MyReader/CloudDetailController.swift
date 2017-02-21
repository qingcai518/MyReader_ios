//
//  CloudDetailController.swift
//  MyReader
//
//  Created by RN-079 on 2017/02/21.
//  Copyright © 2017年 RN-079. All rights reserved.
//

import UIKit
import Kingfisher

class CloudDetailController: ViewController {
    @IBOutlet weak var tableView : UITableView!
    
    var bookInfo: CloudBookInfo!  // params.
    
    @IBAction func doDownload() {
        print("begin to download file.")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
}

extension CloudDetailController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = AppUtility.getTextHeight(text: bookInfo.detail, width: screenWidth - 2 * 16, font: UIFont.Helvetica14())
        return 24 + 120 + 24 + 1 + 16 + 20 + 8 + height + 24
    }
}

extension CloudDetailController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CloudDetailCell", for: indexPath) as! CloudDetailCell
        cell.bookImgView.kf.setImage(with: URL(string: bookInfo.bookImgUrl)!)
        cell.bookNameLbl.text = bookInfo.bookName
        cell.authorLbl.text = bookInfo.authorName
        cell.cosmosView.rating = bookInfo.rating
        cell.cosmosView.text = String(bookInfo.rating)
        cell.detailLbl.text = bookInfo.detail
        
        return cell
    }
}
