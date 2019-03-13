//
//  ScanViewStyle+Demos.swift
//  Example
//
//  Created by 骆扬 on 2019/3/7.
//  Copyright © 2019 GTMYang. All rights reserved.
//

import UIKit
import GTMBarcodeScanner

extension StyleMaker {
    
    func wechat() {
        positionUpVal(44)
        anglePosition(ScanViewStyle.AnglePosition.inner)
        angleLineWeight(3)
        angleLineLength(18)
        isShowRetangleBorder(true)
        animateType(ScanViewStyle.Animation.lineMove)
        retangleLineWeight(1/UIScreen.main.scale)
        colorOfRetangleLine(.lightGray)
        colorOfAngleLine(UIColor(red: 0.0/255, green: 200.0/255.0, blue: 20.0/255.0, alpha: 1.0))
    }
    
    func alipay() {
        let color = UIColor.init(red: 90/255, green: 170/255, blue: 253/255, alpha: 1)
        positionUpVal(44)
        anglePosition(ScanViewStyle.AnglePosition.inner)
        angleLineWeight(4)
        angleLineLength(18)
        isShowRetangleBorder(true)
        retangleLineWeight(1)
        animateType(ScanViewStyle.Animation.gridGrow)
        colorOfAngleLine(color)
        colorOfRetangleLine(color)
    }
    
    func custom() {
        let color = UIColor.init(red: 255/255, green: 157/255, blue: 0/255, alpha: 1)
        positionUpVal(44)
        anglePosition(ScanViewStyle.AnglePosition.inner)
        angleLineWeight(5)
        angleLineLength(18)
        isShowRetangleBorder(true)
        width(280)
        height(180)
        retangleLineWeight(1/UIScreen.main.scale)
        animateType(ScanViewStyle.Animation.lineMove)
        colorOfAngleLine(color)
        colorOfRetangleLine(color)
        let c = UIColor(red: 255/255, green: 157/255, blue: 0/255, alpha: 0.5)
        colorOutside(c)
    }

    
}
