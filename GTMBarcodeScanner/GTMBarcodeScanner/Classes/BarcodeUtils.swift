//
//  BarcodeUtils.swift
//  GTMBarcodeScanner
//
//  Created by 骆扬 on 2019/3/5.
//  Copyright © 2019 GTMYang. All rights reserved.
//

import UIKit
import AVFoundation

public class BarcodeUtils {
    //MARK: ------获取系统默认支持的码的类型
    public static func defaultCodeTypes() ->[AVMetadataObject.ObjectType]
    {
        let types =
            [  AVMetadataObject.ObjectType.ean13,
//             AVMetadataObject.ObjectType.upce,
//             AVMetadataObject.ObjectType.code39,
//             AVMetadataObject.ObjectType.code39Mod43,
             AVMetadataObject.ObjectType.ean8,
//             AVMetadataObject.ObjectType.code93,
             AVMetadataObject.ObjectType.code128,
//             AVMetadataObject.ObjectType.pdf417,
//             AVMetadataObject.ObjectType.aztec,
             AVMetadataObject.ObjectType.qr
        ]
        
//        types.append(AVMetadataObject.ObjectType.interleaved2of5)
//        types.append(AVMetadataObject.ObjectType.itf14)
//        types.append(AVMetadataObject.ObjectType.dataMatrix)
        return types as [AVMetadataObject.ObjectType]
    }
   
    
    // MARK: - 二维码生成
    public typealias CodeType = AVMetadataObject.ObjectType
    
    /// 生成条码，可设置背景色及二维码颜色
    static public func create(_ type: CodeType = CodeType.qr, _ value: String, _ size:CGSize, _ color:UIColor = .black, _ bgColor:UIColor = .white ) -> UIImage? {
        
        let data = value.data(using: String.Encoding.utf8)
        
        //系统自带能生成的码
        //        CIAztecCodeGenerator 二维码
        //        CICode128BarcodeGenerator 条形码
        //        CIPDF417BarcodeGenerator
        //        CIQRCodeGenerator 二维码
        if let filter = CIFilter(name: type.ciString) {
            filter.setValue(data, forKey: "inputMessage")
            if type == .qr {
                filter.setValue("H", forKey: "inputCorrectionLevel")
            }
            
            //上色
            let colored = CIFilter(name: "CIFalseColor", parameters: ["inputImage": filter.outputImage!,"inputColor0": CIColor(cgColor: color.cgColor), "inputColor1": CIColor(cgColor: bgColor.cgColor)])
            
            if let image = colored?.outputImage {
                //绘制
                let cgImage = CIContext().createCGImage(image, from: image.extent)!
                
                UIGraphicsBeginImageContext(size)
                let context = UIGraphicsGetCurrentContext()!
                context.interpolationQuality = CGInterpolationQuality.none
                context.scaleBy(x: 1.0, y: -1.0)
                context.draw(cgImage, in: context.boundingBoxOfClipPath)
                let codeImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                
                return codeImage
            }
        }
        
        return nil
    }
    
    /// 生成带 logo 的二维码
    static public func create(_ type: CodeType, _ value:String, _ size: CGSize, _ color:UIColor = .black, _ bgColor:UIColor = .white, withLogo logo: UIImage, andLogoSize logoSize: CGSize) -> UIImage? {
        
        if let image = create(type, value, size, color, bgColor) {
            return image.composition(image: logo, compSize: logoSize)
        }
        return nil
    }
    
    /// 生成 code128 条码
    static public func createCode128(_ value:String, _ size: CGSize, _ color:UIColor = .black, _ bgColor:UIColor = .white) -> UIImage? {
        
        if let image = create(.code128, value, size, color, bgColor) {
            return image.resize(quality: .none, ratio: 1)
        }
        return nil
    }
    
    /// 根据扫描结果，获取图像中得二维码区域图像
    static func getClippedCodeImage(source: UIImage, codeResult: BarcodeResult) -> UIImage? {
        
        let area = getCodeArea(fromImage: source, ByCodeResult: codeResult)
        
        if area.isEmpty {
            return nil
        }
        
        if let img = source.crop(area) {
            return img.rotate(orientation: .right)
        }
        return nil
    }
    
    
    /// 根据二维码的区域截取二维码区域图像
    static func clippingCodeImage(image:UIImage, area:CGRect) -> UIImage? {
        if area.isEmpty {
            return nil
        }
        
        if let img = image.crop(area) {
            return img.rotate(orientation: UIImage.Orientation.right)
        }
        return nil
    }
    
    /// 获取二维码 frame
    static func getCodeArea(fromImage source:UIImage, ByCodeResult result:BarcodeResult) -> CGRect {
        if let corner = result.corners, corner.count >= 4 {
            
            let tl     = corner[0]
            let tr    = corner[1]
            let br = corner[2]
            let bl  = corner[3]
            
            let tlX:CGFloat = tl.x
            let txY:CGFloat  = tl.y
            
            let trX:CGFloat = tr.x
            let trY:CGFloat = tr.y
            
            let brX:CGFloat = br.x
            let brY:CGFloat = br.y
            
            let blX:CGFloat = bl.x
            let blY:CGFloat = bl.y
            
            //由于截图只能矩形，所以截图不规则四边形的最大外围
            let xMinLeft = CGFloat( min(tlX, blX) )
            let xMaxRight = CGFloat( max(trX, brX) )
            
            let yMinTop = CGFloat( min(txY, trY) )
            let yMaxBottom = CGFloat ( max(blY, brY) )
            
            let imgW = source.size.width
            let imgH = source.size.height
            
            //宽高反过来计算
            let rect = CGRect(x: xMinLeft * imgH, y: yMinTop*imgW, width: (xMaxRight-xMinLeft)*imgH, height: (yMaxBottom-yMinTop)*imgW)
            return rect
        }
        
        return CGRect.zero
    }
   
}


//        CIAztecCodeGenerator 二维码
//        CICode128BarcodeGenerator 条形码
//        CIPDF417BarcodeGenerator
//        CIQRCodeGenerator 二维码
extension AVMetadataObject.ObjectType {
    
    var ciString: String {
        switch self {
        case AVMetadataObject.ObjectType.aztec:
            return "CIAztecCodeGenerator"
        case AVMetadataObject.ObjectType.code128:
            return "CICode128BarcodeGenerator"
        case AVMetadataObject.ObjectType.pdf417:
            return "CIAztecCodeGenerator"
        case AVMetadataObject.ObjectType.qr:
            return "CIQRCodeGenerator"
        default:
            return "CIAztecCodeGenerator"
        }
    }
}

extension UIImage {
    
    /// 叠加图片
    public func composition(image: UIImage, compSize: CGSize) -> UIImage? {
        let source = self
        let size = source.size
        UIGraphicsBeginImageContext(source.size)
        source.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let rect = CGRect(x: size.width/2 - compSize.width/2, y: size.height/2-compSize.height/2, width:compSize.width, height: compSize.height)
        
        image.draw(in: rect)
        let composited = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return composited
    }
    
    /// 图像缩放
    func resize(quality:CGInterpolationQuality, ratio:CGFloat)->UIImage? {
        var resized:UIImage?
        
        let width    = self.size.width * ratio
        let height   = self.size.height * ratio
        
        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        let context = UIGraphicsGetCurrentContext()
        context!.interpolationQuality = quality
        self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        
        resized = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resized
    }
    
    
    /// 图像裁剪
    func crop(_ rect:CGRect) -> UIImage? {
        let imageRef = self.cgImage
        let imagePartRef = imageRef!.cropping(to: rect)
        return UIImage(cgImage: imagePartRef!)
    }
    /// 图像旋转
    func rotate(orientation: UIImage.Orientation) -> UIImage {
        var rotate:Double = 0.0
        var rect:CGRect
        var translateX:CGFloat = 0.0
        var translateY:CGFloat = 0.0
        var scaleX:CGFloat = 1.0
        var scaleY:CGFloat = 1.0
        
        switch (orientation) {
        case UIImage.Orientation.left:
            rotate = .pi/2
            rect = CGRect(x: 0, y: 0, width: self.size.height, height: self.size.width)
            translateX = 0
            translateY = -rect.size.width
            scaleY = rect.size.width/rect.size.height
            scaleX = rect.size.height/rect.size.width
            break
        case UIImage.Orientation.right:
            rotate = 3 * .pi/2
            rect = CGRect(x: 0, y: 0, width: self.size.height, height: self.size.width)
            translateX = -rect.size.height
            translateY = 0
            scaleY = rect.size.width/rect.size.height
            scaleX = rect.size.height/rect.size.width
            break
        case UIImage.Orientation.down:
            rotate = .pi
            rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
            translateX = -rect.size.width
            translateY = -rect.size.height
            break
        default:
            rotate = 0.0
            rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
            translateX = 0
            translateY = 0
            break
        }
        
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()!
        //做CTM变换
        context.translateBy(x: 0.0, y: rect.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.rotate(by: CGFloat(rotate))
        context.translateBy(x: translateX, y: translateY)
        
        context.scaleBy(x: scaleX, y: scaleY)
        //绘制图片
        context.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: rect.size.width, height: rect.size.height))
        let newPic = UIGraphicsGetImageFromCurrentImageContext()
        
        return newPic!
    }
}
