//
//  BooksController.swift
//  MyReader
//
//  Created by RN-079 on 2017/02/20.
//  Copyright © 2017年 RN-079. All rights reserved.
//

import UIKit

class BooksController: ViewController {
    @IBOutlet weak var collectionView : UICollectionView!
    
    let model = BooksModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setRecieveNotification()
        setCollectionView()
        getData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setRecieveNotification() {
        NotificationCenter.default.rx.notification(Notification.Name(rawValue: NotificationName.FinishDownload)).bindNext { [weak self] sender in
            
            print("here")
            
            self?.getData()
        }.addDisposableTo(disposeBag)
    }
    
    private func setCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func getData() {
        model.getBookInfos { [weak self] msg in
            if let errorMsg = msg {
                print("error = \(errorMsg)")
            }
            
            self?.collectionView.reloadData()
        }
    }
}

extension BooksController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let alertController = UIAlertController(title: "", message: "确定要删除这本书吗？", preferredStyle: .alert)
        let actionOK = UIAlertAction(title: "OK", style: .default) { [weak self] alert in
            guard let bookInfo = self?.model.bookInfos[indexPath.row] else {return}
            self?.model.removeBookById(bookId: bookInfo.bookId, completion: { msg in
                if let errorMsg = msg {
                    print("error = \(errorMsg)")
                }
                
                self?.collectionView.reloadData()
            })
        }
        let actionCancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(actionOK)
        alertController.addAction(actionCancel)
        
        self.present(alertController, animated: true, completion: nil)
    }
}

extension BooksController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (screenWidth - 4 * 10) / 3
        let height = width * 1.8
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(10, 10, 10, 10)
    }
}

extension BooksController : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.bookInfos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let info = model.bookInfos[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BooksCell", for: indexPath) as! BooksCell
        cell.bookNameLbl.text = info.bookName
        cell.authorLbl.text = info.authorName
        cell.bookImgView.kf.setImage(with: URL(string: info.bookImgUrl))
        
        return cell
    }
}
