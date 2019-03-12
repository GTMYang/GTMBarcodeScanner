//
//  MaskView.swift
//  GTMBarcodeScanner
//
//  Created by 骆扬 on 2019/3/4.
//  Copyright © 2019 GTMYang. All rights reserved.
//

import UIKit

class ScanView: UIView {
    //扫码区域各种参数
    var style: ScanViewStyle = ScanViewStyle()
    
    //扫码区域
    var scanRetangleRect:CGRect = CGRect.zero
    
    var animation: ScanAnimation?
    
    //启动相机时 菊花等待
    var activityView:UIActivityIndicatorView?
    
    // 动效 view
    var animateView: UIImageView?
    
    //启动相机中的提示文字
    var labelPreparing:UILabel?
    
    //记录动画状态
    var isAnimationing:Bool = false
    
    var scanInterestRect: CGRect?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.clear
        setup()
    }
    
    deinit {
        animation?.stop()
    }
    
    func setup() {
        let w = style.size.width, h = style.size.height
        let x = (frame.size.width - w)/2,
        y = (frame.size.height - h)/2 - style.positionUpVal,
        lineH: CGFloat = 10
        
        var f = CGRect(x: x, y: y, width: w, height: lineH)
        if animateView == nil {
            animateView = UIImageView()
        }
        animateView?.frame = f
        animateView?.contentMode = .center
        animateView?.image = style.animateImage
        self.addSubview(animateView!)
        
        f.size.height = h
        
        let screenW = UIScreen.main.bounds.size.width,
            screenH = UIScreen.main.bounds.size.height,
        o = f.origin, s = self.bounds.size
        // 识别区坐标转换
        scanInterestRect = CGRect(x: o.y/screenH, y: o.x/screenW, width: f.size.height/s.height, height: f.size.width/s.width)
        
        switch (style.animateType)
        {
        case ScanViewStyle.Animation.lineMove:
            animation = LineMoveAnimation(beginY: f.origin.y, endY: f.origin.y + style.size.height - lineH, animationV: animateView!, duration: style.animateDuration)
            if style.animateImage == nil {
                animateView?.image = UIImage(named: "qrcode_scan_line_green", in: Bundle.mine, compatibleWith: nil)
            }
            break
        case ScanViewStyle.Animation.gridGrow:
            animateView?.layer.masksToBounds = true
            animateView?.contentMode = .bottom
            animation = GridMoveAnimation(beginHeight: 0, endHeight: style.size.height, animationV: animateView!, duration: style.animateDuration)
            if style.animateImage == nil {
                animateView?.image = UIImage(named: "qrcode_scan_net", in: Bundle.mine, compatibleWith: nil)
            }
            break
        default:
            break
        }
        
    }
    
    func setStyle(style: ScanViewStyle) {
        self.style = style
        setup()
    }
    
    
    /**
     *  开始扫描动画
     */
    func startScanAnimation() {
        if isAnimationing {
            return
        }
        isAnimationing = true
        animation?.start()
    }
    
    /**
     *  开始扫描动画
     */
    func stopScanAnimation()
    {
        isAnimationing = false
        animation?.stop()
    }
    
    
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override open func draw(_ rect: CGRect) {
        // Drawing code
        DebugUtils.p("GTMBarcodeScanner --> override open func draw(_ rect: CGRect)")
        drawScanRect()
    }
    
    //MARK:----- 绘制扫码效果-----
    func drawScanRect() {
        let size = style.size
        
        let beginX = animateView!.frame.origin.x
        let beginY = self.frame.size.height / 2.0 - size.height/2.0 - style.positionUpVal
        let endY = beginY + size.height
        let endX = self.frame.size.width - beginX
        
        let context = UIGraphicsGetCurrentContext()!
        
        
        //非扫码区域半透明
        //设置非识别区域颜色
        context.setFillColor(style.colorOutside.cgColor)
        //填充矩形
        //扫码区域上面填充
        var rect = CGRect(x: 0, y: 0, width: self.frame.size.width, height: beginY)
        context.fill(rect)
        
        
        //扫码区域左边填充
        rect = CGRect(x: 0, y: beginY, width: beginX, height: size.height)
        context.fill(rect)
        
        //扫码区域右边填充
        rect = CGRect(x: endX, y: beginY, width: beginX,height: size.height)
        context.fill(rect)
        
        //扫码区域下面填充
        rect = CGRect(x: 0, y: endY, width: self.frame.size.width,height: self.frame.size.height - endY)
        context.fill(rect)
        //执行绘画
        context.strokePath()
        
        
        if style.isShowRetangle
        {
            //中间画矩形(正方形)
            context.setStrokeColor(style.colorRetangleLine.cgColor)
            context.setLineWidth(1);
            
            context.addRect(CGRect(x: beginX, y: beginY, width: size.width, height: size.height))
            
            //CGContextMoveToPoint(context, XRetangleLeft, YMinRetangle);
            //CGContextAddLineToPoint(context, XRetangleLeft+sizeRetangle.width, YMinRetangle);
            
            context.strokePath()
            
        }
        scanRetangleRect = CGRect(x: beginX, y:  beginY, width: size.width, height: size.height)
        
        
        //画矩形框4格外围相框角
        
        //相框角的宽度和高度
        let wAngle = style.angleW;
        let hAngle = style.angleH;
        
        //4个角的 线的宽度
        let angleLineWeight = style.angleLineWeight      // 角线粗细
        let recLineWeight = style.retangleLineWeight    // 矩形线粗细
        
        //画扫码矩形以及周边半透明黑色坐标参数
        var angleOffset: CGFloat = 0
        
        switch style.anglePosition
        {
        case ScanViewStyle.AnglePosition.outer:
            angleOffset = (angleLineWeight - recLineWeight)/2 //框外面4个角，与框紧密联系在一起
        case ScanViewStyle.AnglePosition.on:
            angleOffset = 0
        case ScanViewStyle.AnglePosition.inner:
            angleOffset = -style.angleLineWeight/2
        }
        
        context.setStrokeColor(style.colorAngleLine.cgColor);
        context.setFillColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0);
        
        // Draw them with a 2.0 stroke width so they are a bit more visible.
        context.setLineWidth(angleLineWeight);
        
        
        //
        let leftX = beginX - angleOffset
        let topY = beginY - angleOffset
        let rightX = endX + angleOffset
        let bottomY = endY + angleOffset
        
        //左上角水平线
        context.move(to: CGPoint(x: leftX-angleLineWeight/2, y: topY))
        context.addLine(to: CGPoint(x: leftX + wAngle, y: topY))
        
        //左上角垂直线
        context.move(to: CGPoint(x: leftX, y: topY-angleLineWeight/2))
        context.addLine(to: CGPoint(x: leftX, y: topY+hAngle))
        
        //左下角水平线
        context.move(to: CGPoint(x: leftX-angleLineWeight/2, y: bottomY))
        context.addLine(to: CGPoint(x: leftX + wAngle, y: bottomY))
        
        //左下角垂直线
        context.move(to: CGPoint(x: leftX, y: bottomY+angleLineWeight/2))
        context.addLine(to: CGPoint(x: leftX, y: bottomY - hAngle))
        
        //右上角水平线
        context.move(to: CGPoint(x: rightX+angleLineWeight/2, y: topY))
        context.addLine(to: CGPoint(x: rightX - wAngle, y: topY))
        
        //右上角垂直线
        context.move(to: CGPoint(x: rightX, y: topY-angleLineWeight/2))
        context.addLine(to: CGPoint(x: rightX, y: topY + hAngle))
        
        //        右下角水平线
        context.move(to: CGPoint(x: rightX+angleLineWeight/2, y: bottomY))
        context.addLine(to: CGPoint(x: rightX - wAngle, y: bottomY))
        
        //右下角垂直线
        context.move(to: CGPoint(x: rightX, y: bottomY+angleLineWeight/2))
        context.addLine(to: CGPoint(x: rightX, y: bottomY - hAngle))
        
        context.strokePath()
    }
    
    //根据矩形区域，获取识别区域
    func getScanRectWithPreView() -> CGRect {
        return scanInterestRect!
    }
    
    
    func startDevicePrepare(preparetxt:String) {
        let XRetangleLeft = scanInterestRect!.origin.x
        
        let size = style.size
        
        //扫码区域Y轴最小坐标
        let YMinRetangle = self.frame.size.height / 2.0 - size.height/2.0 - style.positionUpVal
        
        //设备启动状态提示
        if (activityView == nil)
        {
            self.activityView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            
            activityView?.center = CGPoint(x: XRetangleLeft +  size.width/2 - 50, y: YMinRetangle + size.height/2)
            activityView?.style = UIActivityIndicatorView.Style.whiteLarge
            
            addSubview(activityView!)
            
            
            let labelReadyRect = CGRect(x: activityView!.frame.origin.x + activityView!.frame.size.width + 10, y: activityView!.frame.origin.y, width: 100, height: 30);
            //print("%@",NSStringFromCGRect(labelReadyRect))
            self.labelPreparing = UILabel(frame: labelReadyRect)
            labelPreparing?.text = preparetxt
            labelPreparing?.backgroundColor = UIColor.clear
            labelPreparing?.textColor = UIColor.white
            labelPreparing?.font = UIFont.systemFont(ofSize: 18.0)
            addSubview(labelPreparing!)
        }
        
        addSubview(labelPreparing!)
        activityView?.startAnimating()
        
    }
    
    func devicePrepared() {
        if activityView != nil
        {
            activityView?.stopAnimating()
            activityView?.removeFromSuperview()
            labelPreparing?.removeFromSuperview()
            
            activityView = nil
            labelPreparing = nil
            
        }
    }
}
