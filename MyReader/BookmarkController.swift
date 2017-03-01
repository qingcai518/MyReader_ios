//
//  BookmarkController.swift
//  MyReader
//
//  Created by RN-079 on 2017/03/01.
//  Copyright © 2017年 RN-079. All rights reserved.
//

import UIKit

class BookmarkController: ViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var closeBtn: UIButton!
    
    let model = BookmarkModel()

    @IBAction func doClose() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setRecieveNotifications()
        setTableView()
        getData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setRecieveNotifications() {
        NotificationCenter.default.rx.notification(Notification.Name(rawValue: NotificationName.BookmarkAdded)).bindNext { [weak self] sender in
            // 現在のデータを更新する.
            self?.getData()
        }.addDisposableTo(disposeBag)
    }
    
    private func setTableView() {
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func getData() {
        self.indicator.startAnimating()
        model.getBookmarkInfos { [weak self] msg in
            self?.indicator.stopAnimating()
            
            if let errorMsg = msg {
                print("error message = \(errorMsg)")
                return
            }
            
            self?.tableView.reloadData()
        }
    }
}

extension BookmarkController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 16 + 18 + 8 + 40 + 24
    }
}

extension BookmarkController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.bookmarkInfos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let info = model.bookmarkInfos[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookmarkCell", for: indexPath) as! BookmarkCell
        cell.nameLbl.text = info.bookmarkName
        cell.timeLbl.text = info.bookmarkTime
        cell.contentLbl.text = info.contents
        
        return cell
    }
}
