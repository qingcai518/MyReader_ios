//
//  Setting2Controller.swift
//  MyReader
//
//  Created by RN-079 on 2017/03/16.
//  Copyright © 2017年 RN-079. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class Setting2Controller: UIViewController {
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var leftImgView: UIImageView!
    @IBOutlet weak var rightImgView: UIImageView!
    @IBOutlet weak var sliderView : UISlider!
    @IBOutlet weak var smallBtn: UIButton!
    @IBOutlet weak var bigBtn: UIButton!
    
    let disposeBag = DisposeBag()
    
    @IBAction func changeBrightness(slider: UISlider, event: UIEvent) {
        print("slider value = \(slider.value)")
        UIScreen.main.brightness = CGFloat(slider.value)
        
        // 値を保存する.
        UserDefaults.standard.set(slider.value, forKey: UDKey.Brightness)
        UserDefaults.standard.synchronize()
    }
    
    @IBAction func toSmall() {
        // 文字サイズを縮小する.
        var currentFontSize = UserDefaults.standard.float(forKey: UDKey.FontSize)
        if (currentFontSize == 0) {
            currentFontSize = 18
        }
        
        let fontSize = currentFontSize - 2
        UserDefaults.standard.set(fontSize, forKey: UDKey.FontSize)
        UserDefaults.standard.synchronize()
        
        bigBtn.isEnabled = true
        if (fontSize <= 10) {
            smallBtn.isEnabled = false
        }
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: NotificationName.ChangeFont), object: nil)
    }
    
    @IBAction func toBig() {
        // 文字サイズを拡大する.
        var currentFontSize = UserDefaults.standard.float(forKey: UDKey.FontSize)
        if (currentFontSize == 0) {
            currentFontSize = 18
        }
        
        let fontSize = currentFontSize + 2

        UserDefaults.standard.set(fontSize, forKey: UDKey.FontSize)
        UserDefaults.standard.synchronize()
        
        smallBtn.isEnabled = true
        if (fontSize >= 30) {
            bigBtn.isEnabled = false
        }
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: NotificationName.ChangeFont), object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBottomView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func setBottomView() {
        self.view.backgroundColor = UIColor.init(white: 0, alpha: 0.4)
        // slider view の値の設定.
        let sliderValue = UserDefaults.standard.float(forKey: UDKey.Brightness)
        self.sliderView.value = sliderValue
        
        smallBtn.layer.borderColor = UIColor.blue.cgColor
        smallBtn.layer.borderWidth = 1
        
        bigBtn.layer.borderColor = UIColor.blue.cgColor
        bigBtn.layer.borderWidth = 1
        
        let recognizer = UITapGestureRecognizer()
        recognizer.rx.event.bindNext { [weak self] sender in
            self?.dismiss(animated: true, completion: nil)
        }.addDisposableTo(disposeBag)
        recognizer.delegate = self
        
        self.view.addGestureRecognizer(recognizer)
        
        // 色を変更するボタンを追加する.
        let width = screenWidth / 4
        let size = CGFloat(40)
        let startY = CGFloat(24 + 18 + 24 + 30 + 16)
        let startX = (width - size) / 2
        createCircleBtn(x: startX, y: startY, size: size, bkColor: UIColor.blue, textColor: UIColor.white)
        createCircleBtn(x: width + startX, y: startY, size: size, bkColor: UIColor.red, textColor: UIColor.white)
        createCircleBtn(x: 2 * width + startX, y: startY, size: size, bkColor: UIColor.yellow, textColor: UIColor.black)
        createCircleBtn(x: 3 * width + startX, y: startY, size: size, bkColor: UIColor.orange, textColor: UIColor.black)
        
        // 分割線を追加する.
        let separatorView = UIView(frame: CGRect(x: 0, y: startY + size + 24, width: screenWidth, height: 1))
        separatorView.backgroundColor = UIColor.lightGray
        self.bottomView.addSubview(separatorView)
        
        // more設定ボタンを追加する.
        let moreBtnStartY = startY  + size + 24 + 1
        let moreBtn = UIButton(frame: CGRect(x: 0, y: moreBtnStartY, width: screenWidth, height: 240 - moreBtnStartY))
        moreBtn.setTitle("更多设置", for: .normal)
        moreBtn.titleLabel?.font = UIFont.Helvetica14()
        moreBtn.setTitleColor(UIColor.black, for: .normal)
        
        moreBtn.rx.tap.bindNext { [weak self] in
            let storyboard = UIStoryboard(name: "SetMore", bundle: nil)
            guard let next = storyboard.instantiateInitialViewController() else {
                return
            }
            
            self?.present(next, animated: true, completion: nil)
        }.addDisposableTo(disposeBag)
        
        self.bottomView.addSubview(moreBtn)
    }
    
    private func createCircleBtn(x: CGFloat, y: CGFloat, size: CGFloat, bkColor: UIColor, textColor: UIColor){
        
        let btn = UIButton(frame: CGRect(x: x, y: y, width: size, height: size))
        btn.backgroundColor = bkColor
        btn.setTitleColor(textColor, for: .normal)
        btn.setTitle("A", for: .normal)
        btn.titleLabel?.font = UIFont.Helvetica14()
        btn.layer.cornerRadius = size / 2
        btn.clipsToBounds = true
        
        self.bottomView.addSubview(btn)

        btn.rx.tap.bindNext {
            let bkRGB = UIColor.getRGB(color: bkColor)
            let txtRGB = UIColor.getRGB(color: textColor)
            
            UserDefaults.standard.set(bkRGB.r, forKey: UDKey.BKColor_R)
            UserDefaults.standard.set(bkRGB.g, forKey: UDKey.BKColor_G)
            UserDefaults.standard.set(bkRGB.b, forKey: UDKey.BKColor_B)
            
            UserDefaults.standard.set(txtRGB.r, forKey: UDKey.TxtColor_R)
            UserDefaults.standard.set(txtRGB.g, forKey: UDKey.TxtColor_G)
            UserDefaults.standard.set(txtRGB.b, forKey: UDKey.TxtColor_B)
            
            UserDefaults.standard.synchronize()
            
            // 背景色が変更されたことを通知する.
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationName.ChangeLightMode), object: nil)
        }.addDisposableTo(disposeBag)
    }
}

extension Setting2Controller : UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view == bottomView) {
            return false
        }
        
        return true
    }
}
