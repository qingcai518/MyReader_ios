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
    
    var currentInfo : LocalBookInfo!

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
            self?.getData()
        }.addDisposableTo(disposeBag)
    }
    
    private func setCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let longPress = UILongPressGestureRecognizer(target: self
            , action: #selector(BooksController.onLongPressAction(_:)))
        longPress.allowableMovement = 10
        longPress.minimumPressDuration = 0.5
        self.collectionView.addGestureRecognizer(longPress)
    }

    func onLongPressAction(_ sender: UILongPressGestureRecognizer) {
        let point = sender.location(in: collectionView)
        guard let indexPath = collectionView.indexPathForItem(at: point) else {
            return
        }
        
        switch sender.state {
        case .began:
            let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let action1 = UIAlertAction(title: "删除", style: .destructive, handler: { sender in
                let alert = UIAlertController(title: "", message: "确定要删除吗？", preferredStyle: .alert)
                let actionOK = UIAlertAction(title: "好的", style: .default, handler: { [weak self] alert in
                    guard let bookInfo = self?.model.bookInfos[indexPath.row] else {return}
                    self?.model.removeBookById(bookId: bookInfo.bookId, completion: { msg in
                        if let errorMsg = msg {
                            print("error = \(errorMsg)")
                        }

                        self?.collectionView.reloadData()
                    })
                })
                
                let actionCancel = UIAlertAction(title: "点错了", style: .default, handler: nil)
                alert.addAction(actionOK)
                alert.addAction(actionCancel)
                
                self.present(alert, animated: true, completion: nil)
                
            })
            
            let action2 = UIAlertAction(title: "阅读", style: .default, handler: { sender1 in
            })
            
            let action3 = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            
            sheet.addAction(action1)
            sheet.addAction(action2)
            sheet.addAction(action3)
            
            self.present(sheet, animated: true, completion: nil)
        default:
            break
        }
    }

    private func getData() {
        indicator.startAnimating()
        model.getBookInfos { [weak self] msg in
            self?.indicator.stopAnimating()
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
        
        let bookInfo = model.bookInfos[indexPath.row]

        indicator.startAnimating()
        model.readFile(bookInfo: bookInfo) { [weak self] content in
            self?.indicator.stopAnimating()
            guard let contents = self?.model.pageContents else {
                return
            }
            
            guard let chapterInfos = self?.model.chapterInfos else {
                return
            }
            
            let bookController = BookController(bookInfo: bookInfo, pageContents: contents, chapterInfos: chapterInfos)
            self?.present(bookController, animated: true, completion: nil)
        }
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
