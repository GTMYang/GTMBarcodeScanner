//
//  ViewController.swift
//  Example
//
//  Created by 骆扬 on 2019/3/5.
//  Copyright © 2019 GTMYang. All rights reserved.
//

import UIKit
import GTMBarcodeScanner

class ViewController: UIViewController, GTMBarcodeCoreDelegate {
    var scanner: BarcodeScanner!
    @IBOutlet weak var flashLightButton: PositionableButton!
    var uiType: String = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        flashLightButton.isHidden = true
        self.view.backgroundColor = .black
        
        let scanner = BarcodeScanner.create(view: self.view)
        scanner.makeStyle { (make) in
            if uiType == "wechat" {
                make.wechat()
            }
            if uiType == "alipay" {
                make.alipay()
            }
            //custom
            if uiType == "custom" {
                make.custom()
            }
//            if uiType == "wechat" {
//                make.wechat()
//            }
            make.soundSource(forName: "VoiceSearchOn", andType: "wav")
        }

        
        scanner.delegate = self
        scanner.start()
        self.scanner = scanner
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func onFlashLight(_ sender: UIButton) {
        scanner.toggleFlashLight()
        if scanner.isFlashOn {
            sender.setTitle("轻触关闭", for: .normal)
            sender.setImage(UIImage(named: "flash_on"), for: .normal)
        } else {
            sender.setTitle("轻触打开", for: .normal)
            sender.setImage(UIImage(named: "flash_off"), for: .normal)
        }
    }
    @IBAction func onPhotoAlbarm(_ sender: Any) {
        scanner.openPhotoAlbum(fromController: self)
    }
    
    // MARK: - GTMBarcodeCoreDelegate
    
    func lightnessChange(needFlashButton: Bool) {
//        print("----------> needFlash = \(needFlashButton)")
        flashLightButton.isShow = needFlashButton
    }
    
    func barcodeRecognized(result: BarcodeResult) {
        print("----------> result = \(result.barcode)")
    }
    
    func barcodeForPhoto(result: BarcodeResult?) {
        if let re = result {
            print("----------> result = \(re.barcode)")
        } else {
            print("无法识别图片中的条码")
        }
    }

}

