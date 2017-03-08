//
//  SettingController.swift
//  MyReader
//
//  Created by RN-079 on 2017/03/08.
//  Copyright © 2017年 RN-079. All rights reserved.
//

import UIKit

class SettingController: ViewController {
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var bottomView : UIView!
    @IBOutlet weak var chapterLbl: UILabel!
    @IBOutlet weak var preBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var listBtn: UIButton!
    @IBOutlet weak var bookmarkBtn: UIButton!
    @IBOutlet weak var lightBtn: UIButton!
    @IBOutlet weak var fontBtn: UIButton!
    @IBOutlet weak var addBookmarkBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setView() {
        self.view.backgroundColor = UIColor.init(white: 0, alpha: 0.4)
    }
}
