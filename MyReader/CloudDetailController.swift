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
    
    let model = CloudDetailModel()
    
    var bookInfo: CloudBookInfo!  // params.
    
    @IBAction func doDownload() {
        print("begin to download file.")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()
        getData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
    
    private func getData() {
        model.isDownloaded(bookId: bookInfo.bookId)
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
        
        cell.downloadBtn.rx.tap.asObservable().bindNext { [weak self] in
            guard let info = self?.bookInfo else {return}
            self?.model.downloadFile(bookInfo: info)
        }.addDisposableTo(cell.disposeBag)
        
        model.isDownloaded.asObservable().bindNext { value in
            if(value) {
                cell.downloadBtn.setTitle("打开", for: .normal)
            } else {
                cell.downloadBtn.setTitle("下载", for: .normal)
            }
        }
        
        return cell
    }
}
