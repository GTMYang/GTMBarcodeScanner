//
//  BarcodeScanner+ForPhoto.swift
//  GTMBarcodeScanner
//
//  Created by 骆扬 on 2019/3/8.
//  Copyright © 2019 GTMYang. All rights reserved.
//

import UIKit
import AVFoundation

extension BarcodeScanner: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    public func openPhotoAlbum(fromController contoller: UIViewController) {
        ScanPermissionUtils.authorizePhotoWith { [weak contoller] (granted) in
            let picker = UIImagePickerController()
            picker.sourceType = UIImagePickerController.SourceType.photoLibrary
            picker.delegate = self
            
            contoller?.present(picker, animated: true, completion: nil)
            
            self.session.stopRunning()
        }
    }
    
    
    //MARK: -----相册选择图片识别二维码 （条形码没有找到系统方法）
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let result = recognizeQRImage(image: image)
            self.delegate?.barcodeForPhoto(result: result)
            
            self.session.stopRunning()
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    public func recognizeQRImage(image:UIImage) -> BarcodeResult? {
        
        if #available(iOS 8.0, *) {
            
            let detector:CIDetector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy:CIDetectorAccuracyHigh])!
            let img = CIImage(cgImage: (image.cgImage)!)
            let features:[CIFeature]? = detector.features(in: img, options: [CIDetectorAccuracy:CIDetectorAccuracyHigh])
            
            if let results = features, results.count > 0 {
                let feature = results[0]
                
                if feature.isKind(of: CIQRCodeFeature.self) {
                    let featureTmp:CIQRCodeFeature = feature as! CIQRCodeFeature
                    if let barcode = featureTmp.messageString {
                        return BarcodeResult(code: barcode, type: AVMetadataObject.ObjectType.qr)
                    }
                }
            }
        }
        
        return nil
    }
}
