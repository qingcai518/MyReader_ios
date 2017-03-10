//
//  ChapterController.swift
//  MyReader
//
//  Created by RN-079 on 2017/03/01.
//  Copyright © 2017年 RN-079. All rights reserved.
//

import UIKit

class ChapterController: ViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var closeBtn : UIButton!
    
    // params.
    var chapterInfos = [ChapterInfo]()
    var bookInfo: LocalBookInfo!
    
    @IBAction func doClose() {
        self.dismiss(animated: true, completion: nil)
    }

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

extension ChapterController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(64)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let info = chapterInfos[indexPath.row]
        let startPage = info.startPage
        AppUtility.saveCurrentPage(bookId: bookInfo.bookId, pageIndex: startPage)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationName.ChangeChapter), object: nil)
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}

extension ChapterController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chapterInfos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chapterInfo = chapterInfos[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChapterCell", for: indexPath) as! ChapterCell
        cell.chapterNameLbl.text = chapterInfo.chapterName
        
        return cell
    }
}
