//
//  Navi2Controller.swift
//  MyReader
//
//  Created by RN-079 on 2017/02/20.
//  Copyright © 2017年 RN-079. All rights reserved.
//

import UIKit

class Navi2Controller: NavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyboard = UIStoryboard(name: "Cloud", bundle: nil)
        guard let next = storyboard.instantiateInitialViewController() else {
            return
        }
        
        self.viewControllers = [next]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
