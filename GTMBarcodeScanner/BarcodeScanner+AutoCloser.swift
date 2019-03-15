//
//  BarcodeScanner+AutoCloser.swift
//  GTMBarcodeScanner
//
//  Created by 骆扬 on 2019/3/11.
//  Copyright © 2019 GTMYang. All rights reserved.
//

import UIKit
import AVFoundation

extension BarcodeScanner {
    var autoCloser: Bool {
        return config.isAutoCloser
    }
    
    func autoCloser(obj: AVMetadataMachineReadableCodeObject) {
        guard autoCloser else {
            return
        }
        let coners = obj.corners
        print("coners = \(obj.corners)")
        if coners.count > 2 {
            let lt = coners[0], rb = coners[2]
            let center = CGPoint(x: (lt.x + rb.x) / 2 , y: (lt.y + rb.y) / 2)
           
            let codeW = rb.x - lt.x
            if 150 > codeW {
                let scanAreaW = BarcodeScanner.scanView!.style.size.width
                let scale = (scanAreaW - 30)/(rb.x - lt.x)
                self.scaleVideo(scale, center)
            }
        }
    }
    
    func scaleVideo(_ scale: CGFloat, _ center: CGPoint = .zero) {
        guard let input = deviceInput else {
            return
        }
        
        var output: AVCaptureOutput? = self.imageOutput
        if #available(iOS 10.0, *) {
            output = self.photoOutput
        }
        
        var _scale = scale
        try? input.device.lockForConfiguration()
        if let con = connection(withMediaType: AVMediaType.video, connections: output!.connections) {
            let maxScaleAndCropFactor = con.videoMaxScaleAndCropFactor/16
            if _scale > maxScaleAndCropFactor {
                _scale = maxScaleAndCropFactor
            }

            let zoom = _scale / con.videoScaleAndCropFactor
            con.videoScaleAndCropFactor = _scale
            
            input.device.unlockForConfiguration()
            
            
            Debug.p("GTMBarcodeScanner --> _scale : \(_scale)")
            Debug.p("GTMBarcodeScanner --> zoom : \(zoom)")
            Debug.p("GTMBarcodeScanner --> con.videoScaleAndCropFactor : \(con.videoScaleAndCropFactor)")
            let transform = previewLayer!.transform
            if _scale == 1 {
                previewLayer?.transform = CATransform3DScale(transform, zoom, zoom, 1)
                var frame = previewLayer!.frame
                frame.origin = .zero
                previewLayer?.frame = frame
            } else {
                let x = previewLayer!.center.x - center.x
                let y = previewLayer!.center.y - center.y

                Debug.p("previewLayer!.center : \(previewLayer!.center.x) y: \(previewLayer!.center.y)")
                Debug.p("center : \(center.x) y: \(center.y)")
                Debug.p("GTMBarcodeScanner --> x : \(x) y: \(y)")
                var frame = previewLayer!.frame
                frame.origin.x = frame.size.width / 2 * (1-_scale)
                frame.origin.y = frame.size.height / 2 * (1-_scale)
                frame.origin.x += x * zoom
                frame.origin.y += y * zoom
                frame.size.width = frame.size.width * _scale
                frame.size.height = frame.size.height * _scale

                UIView.animate(withDuration: 0.5) {
                    self.previewLayer?.transform = CATransform3DScale(transform, zoom, zoom, 1)
                    self.previewLayer?.frame = frame
                }
            }
        } else {
            input.device.unlockForConfiguration()
        }
    }
}

extension CALayer {
    var center: CGPoint {
        return CGPoint(x: frame.origin.x + frame.size.width/2, y: frame.origin.y + frame.size.height/2)
    }
}

