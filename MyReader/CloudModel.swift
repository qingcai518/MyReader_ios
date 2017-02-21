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
    var cloudBooks = [CloudBookInfo]()
    
    func getCloudBooks(completion: @escaping (String?) -> Void) {
        Alamofire.request(bookService).responseJSON { [weak self] response in
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
            
            return completion(nil)
        }
    }
}
