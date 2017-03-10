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
    @IBOutlet weak var closeBtn: UIButton!
    
    // params.
    var bookInfo: LocalBookInfo!
    
    let model = BookmarkModel()

    @IBAction func doClose() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createIndicator()
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
        startIndicator()
        model.getBookmarkInfos { [weak self] msg in
            self?.stopIndicator()
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let info = model.bookmarkInfos[indexPath.row]
        let currentPage = info.pageNumber
        
        AppUtility.saveCurrentPage(bookId: bookInfo.bookId, pageIndex: currentPage)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationName.ChangeChapter), object: nil)
        
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        
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
