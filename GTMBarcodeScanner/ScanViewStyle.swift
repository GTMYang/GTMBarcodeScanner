//
//  ScannerStyle.swift
//  GTMBarcodeScanner
//
//  Created by 骆扬 on 2019/3/4.
//  Copyright © 2019 GTMYang. All rights reserved.
//

import UIKit


public struct ScanViewStyle {
    
    public enum Animation {
        case lineMove
        case gridGrow
        case none
    }
    
    public enum AnglePosition {
        case inner
        case outer
        case on
    }
    
    /// 是否需要绘制扫码矩形框，默认YES
    public var isShowRetangle:Bool = true
    public var size = CGSize(width: 255, height: 255)
    public var positionUpVal: CGFloat = 44
    ///矩形框线条颜色，默认白色
    public var colorRetangleLine = UIColor.white
    ///4个角的颜色
    public var colorAngleLine = UIColor(red: 0.0, green: 167.0/255.0, blue: 231.0/255.0, alpha: 1.0)
    ///非识别区域颜色,默认 RGBA (0,0,0,0.5)，范围（0--1）
    public var colorOutside = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
    
    ///扫码区域的4个角类型
    public var anglePosition = AnglePosition.outer
    

    ///扫码区域4个角的宽度和高度
    public var angleW:CGFloat = 24.0
    public var angleH:CGFloat = 24.0
    ///扫码区域4个角的线条宽度,默认6，建议8到4之间
    public var angleLineWeight: CGFloat = 6
    public var retangleLineWeight: CGFloat = 1
    
    ///扫码动画效果: 线条或网格
    public var animateType = Animation.lineMove
    
    /// 动画效果的图像，如线条或网格的图像
    public var animateImage:UIImage?
    /// 动画 duration 值, 默认值 2.6
    public var animateDuration: TimeInterval = 2.6
    
    /// 扫描提示音资源文件
    public var soundSource: (name: String, type: String)?
    
    
    public init() { }
}

public class StyleMaker {
    typealias Position = ScanViewStyle.AnglePosition
    typealias Animation = ScanViewStyle.Animation
    var style: ScanViewStyle
    init() {
        style = ScanViewStyle()
    }
    
    public func likeWechat() {
        
    }
    public func likeAlipay() {
        
    }
    
    /// 是否显示扫描区 border
    @discardableResult
    public func isShowRetangleBorder(_ show: Bool) -> StyleMaker {
        style.isShowRetangle = show
        return self
    }
    /// 扫描区宽度
    @discardableResult
    public func width(_ w: CGFloat) -> StyleMaker {
        style.size.width = w
        return self
    }
    /// 扫描区高度
    @discardableResult
    public func height(_ h: CGFloat) -> StyleMaker {
        style.size.height = h
        return self
    }
    /// 中心点上移的值（相对于扫码界面的中心）
    @discardableResult
    public func positionUpVal(_ v: CGFloat) -> StyleMaker {
        style.positionUpVal = v
        return self
    }
    
    /// 扫描区域border颜色
    @discardableResult
    public func colorOfRetangleLine(_ c: UIColor) -> StyleMaker {
        style.colorRetangleLine = c
        return self
    }
    /// 角线颜色
    @discardableResult
    public func colorOfAngleLine(_ c: UIColor) -> StyleMaker {
        style.colorAngleLine = c
        return self
    }
    /// 扫描区外的颜色
    @discardableResult
    public func colorOutside(_ c: UIColor) -> StyleMaker {
        style.colorOutside = c
        return self
    }
    
    /// 角线位置
    @discardableResult
    public func anglePosition(_ p: ScanViewStyle.AnglePosition) -> StyleMaker {
        style.anglePosition = p
        return self
    }
    /// 角线长度
    @discardableResult
    public func angleLineLength(_ l: CGFloat) -> StyleMaker {
        style.angleW = l
        style.angleH = l
        return self
    }
    /// 扫描区角线粗细
    @discardableResult
    public func angleLineWeight(_ weight: CGFloat) -> StyleMaker {
        style.angleLineWeight = weight
        return self
    }
    /// 扫描区 border 粗细
    @discardableResult
    public func retangleLineWeight(_ weight: CGFloat) -> StyleMaker {
        style.retangleLineWeight = weight
        return self
    }
    /// 动画类型 （lineMove: 滚动的线条, gridGrow：伸展的网格）
    @discardableResult
    public func animateType(_ t: ScanViewStyle.Animation) -> StyleMaker {
        style.animateType = t
        return self
    }
    /// 动画图片
    @discardableResult
    public func animateImage(_ img: UIImage) -> StyleMaker {
        style.animateImage = img
        return self
    }
    /// 动画图片名
    @discardableResult
    public func animateImageName(_ n: String) -> StyleMaker {
        style.animateImage = UIImage(named: n)
        return self
    }
    
    /// 动画 duration 值, 默认值 2.6
    @discardableResult
    public func duration(_ d: TimeInterval) -> StyleMaker {
        style.animateDuration = d
        return self
    }
    
    @discardableResult
    public func soundSource(forName n: String, andType t: String) -> StyleMaker {
        style.soundSource = (n, t)
        return self
    }
}

extension ScannerSound {
    
    static func sound(forStyle style: ScanViewStyle) {
        if let source = style.soundSource {
            self.sound(forResource: source.name, ofType: source.type)
        } else {
            self.defSound()
        }
    }
}

