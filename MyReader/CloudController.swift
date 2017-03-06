//
//  CloudController.swift
//  MyReader
//
//  Created by RN-079 on 2017/02/20.
//  Copyright © 2017年 RN-079. All rights reserved.
//

import UIKit
import MJRefresh
import Kingfisher

class CloudController: ViewController {
    @IBOutlet weak var tableView : UITableView!
    
    let model = CloudModel()
    var header : MJRefreshGifHeader!
    var footer : MJRefreshAutoNormalFooter!
    
    var currentInfo : CloudBookInfo!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        createIndicator()
        setRefreshHeaderAndFooter()
        setTableView()
        getData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setRefreshHeaderAndFooter() {
        header = MJRefreshGifHeader(refreshingTarget: self, refreshingAction: #selector(getData))
        footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(getMoreData))
        
        header.setImages(AppUtility.getIdleImages(), for: .idle)
        header.setImages(AppUtility.getPullingImages(), for: .pulling)
        header.setImages(AppUtility.getRefreshingImages(), duration: 1, for: .refreshing)
        
        footer.isHidden = true
        
        tableView.mj_header = header
        tableView.mj_footer = footer
    }
    
    private func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
    
    func getData() {
        startIndicator()
        model.getCloudBooks { [weak self] msg in
            self?.header.endRefreshing()
            self?.stopIndicator()
            
            if let errorMsg = msg {
                print("error = \(errorMsg)")
            } else {
                self?.footer.isHidden = false
            }
            
            self?.tableView.reloadData()
        }
    }
    
    func getMoreData() {
        model.getMoreCloudBooks { [weak self] (msg, isLast) in
            self?.footer.endRefreshing()
            self?.footer.isHidden = isLast
            
            if let errorMsg = msg {
                print("error = \(errorMsg)")
            }
            
            self?.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ToCloudDetail") {
            guard let next = segue.destination as? CloudDetailController else {
                return
            }
            
            next.bookInfo = currentInfo
            next.hidesBottomBarWhenPushed = true
        }
    }
}

extension CloudController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 144
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        currentInfo = model.cloudBooks[indexPath.row]
        self.performSegue(withIdentifier: "ToCloudDetail", sender: nil)
    }
}

extension CloudController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.cloudBooks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let info = model.cloudBooks[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CloudCell", for: indexPath) as! CloudCell
        cell.bookNameLbl.text = info.bookName
        cell.bookImgView.kf.setImage(with: URL(string: info.bookImgUrl))
        cell.authorNameLbl.text = info.authorName
        cell.detailLbl.text = info.detail
        cell.cosmosView.rating  = info.rating
        cell.cosmosView.text = String(info.rating)
        
        return cell
    }
}
