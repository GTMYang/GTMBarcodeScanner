//
//  ScannerSound.swift
//  GTMBarcodeScanner
//
//  Created by 骆扬 on 2019/3/7.
//  Copyright © 2019 GTMYang. All rights reserved.
//

import UIKit
import AudioToolbox

class ScannerSound {
    
    static func defSound() {
//        //声明一个系统声音标示类型声音变量
//        var _soundId: SystemSoundID = 0
//        //获取沙箱目录中文件所在的路径
//        let path = Bundle.mine.path(forResource: "qrcode_found", ofType: "wav")
//        //将字符串路径转换为网址路径
//        let soundUrl = URL(fileURLWithPath: path!)
//
//        AudioServicesCreateSystemSoundID(soundUrl as CFURL, &_soundId)
//        AudioServicesPlaySystemSound(_soundId)
    }
    
    static func sound(forResource resource: String, ofType type: String) {
        //声明一个系统声音标示类型声音变量
        var _soundId: SystemSoundID = 0
        //获取沙箱目录中文件所在的路径
        let path = Bundle.main.path(forResource: resource, ofType: type)
        
        //将字符串路径转换为网址路径
        let soundUrl = URL(fileURLWithPath: path!)
        
        AudioServicesCreateSystemSoundID(soundUrl as CFURL, &_soundId)
        AudioServicesPlaySystemSound(_soundId)
    }
}
