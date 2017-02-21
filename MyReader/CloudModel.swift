//
//  CloudModel.swift
//  MyReader
//
//  Created by RN-079 on 2017/02/20.
//  Copyright © 2017年 RN-079. All rights reserved.
//

import Foundation
import Alamofire

class CloudModel : AnyObject {
    private var offset = 0
    private let count = 30
    
    var cloudBooks = [CloudBookInfo]()
    
    func getCloudBooks(completion: @escaping (String?) -> Void) {
        let params : [String: Any] = ["offset": 0, "hit_per_page" : count]
        
        Alamofire.request(bookService, parameters : params).responseJSON { [weak self] response in
            if let error = response.result.error {
                return completion(error.localizedDescription)
            }
            
            guard let results = response.result.value as? NSArray else {
                return completion("fail to get json.")
            }
            
            self?.cloudBooks.removeAll()
            
            for result in results {
                guard let resultDic = result as? NSDictionary else {
                    continue
                }
                
                guard let info = CloudBookInfo(dic: resultDic) else {
                    continue
                }
                
                self?.cloudBooks.append(info)
            }
            
            if let currentOffset = self?.offset {
                self?.offset = currentOffset + results.count
            }
            
            return completion(nil)
        }
    }
    
    func getMoreCloudBooks(completion: @escaping (String?, Bool) -> Void) {
        let params : [String : Any] = ["offset": offset, "hit_per_page" : count]
        
        Alamofire.request(bookService, parameters: params).responseJSON { [weak self] response in
            if let error = response.result.error {
                return completion(error.localizedDescription, false)
            }
            
            guard let results = response.result.value as? NSArray else {
                return completion("fail to get json.", false)
            }
            
            let beforeCount = self?.cloudBooks.count
            
            for result in results {
                guard let resultDic = result as? NSDictionary else {
                    continue
                }
                
                guard let info = CloudBookInfo(dic: resultDic) else {
                    continue
                }
                
                self?.cloudBooks.append(info)
            }
            if let currentOffset = self?.offset {
                self?.offset = currentOffset + results.count
            }
            
            let afterCount = self?.cloudBooks.count
            let isLast = beforeCount == afterCount
            
            return completion(nil, isLast)
        }
    }
}
