//
//  GTMBarcodeScanner.swift
//  GTMBarcodeScanner
//
//  Created by 骆扬 on 2019/3/4.
//  Copyright © 2019 GTMYang. All rights reserved.
//

import UIKit
import AVFoundation
import ImageIO

public struct BarcodeResult {
    public var barcode: String
    public var barcodeType: AVMetadataObject.ObjectType
    public var image: UIImage?
    //码在图像中的位置
    public var corners: [CGPoint]?
    init(code: String, type: AVMetadataObject.ObjectType) {
        barcode = code
        barcodeType = type
    }
}

public protocol GTMBarcodeCoreDelegate: class {
    func barcodeRecognized(result: BarcodeResult)
    func lightnessChange(needFlashButton: Bool)
    func barcodeForPhoto(result: BarcodeResult?)
}
extension GTMBarcodeCoreDelegate {
    func lightnessChange(needFlashButton: Bool) {} // 不需要的时候可以不实现
    func barcodeForPhoto(result: BarcodeResult?) {} // 不需要的时候可以不实现
}

public class BarcodeScanner: NSObject {
    typealias Debug = DebugUtils
    public weak var delegate: GTMBarcodeCoreDelegate?
    
    var device: AVCaptureDevice?
    var deviceInput: AVCaptureDeviceInput?
    var session: AVCaptureSession!
    var previewLayer:AVCaptureVideoPreviewLayer?

   // @available(iOS 8.0, *)
    @available(iOS, introduced: 8.0, deprecated: 10.0, message: "Use photoOutput instead.")
    var imageOutput:AVCaptureStillImageOutput? {
        return _imgOutput as? AVCaptureStillImageOutput
    }
    @available(iOS 10.0, *)
    var photoOutput:AVCapturePhotoOutput? {
        return _imgOutput as? AVCapturePhotoOutput
    }
    var _imgOutput: AVCaptureOutput?
    
    var lightOutput:AVCaptureVideoDataOutput?
    
    var isBarcodeReconged: Bool = false
    var result: BarcodeResult?
    var isLightDetecting = false
    static var scanView: ScanView?
    
    init(codeTypes: [AVMetadataObject.ObjectType],videoPreView: UIView, prepareTxt: String = "设备准备中...") {
        
        // Input
        let videoDevice = AVCaptureDevice.default(for: AVMediaType.video)
        do {
            deviceInput = try AVCaptureDeviceInput(device: videoDevice!)
            // Session
            session = AVCaptureSession()
            session.addInput(deviceInput!)
            
            device = videoDevice
        } catch let error as NSError {
            Debug.p("GTMBarcodeScanner --> AVCaptureDeviceInput(): \(error)")
        }
        
        super.init()
        
        // Output
        let metadataOutput = AVCaptureMetadataOutput()
        // Add metadata Output
        if session.canAddOutput(metadataOutput) {
            session.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]//codeTypes
            
            if let rect = BarcodeScanner.scanView?.scanInterestRect {
                metadataOutput.rectOfInterest = rect
            }
            
            Debug.p("GTMBarcodeScanner --> add metadataOutput")
        } else {
            Debug.p("GTMBarcodeScanner --> Can not add AVCaptureMetadataOutput")
        }
        
        // 图片输出
        if ScannerConfig.shared.isCaputureImage {
            if #available(iOS 10.0, *) {
                let output = AVCapturePhotoOutput()
                if session.canAddOutput(output) {
                    session.addOutput(output)
                    let settings = AVCapturePhotoSettings()
                    output.capturePhoto(with: settings, delegate: self)
                    _imgOutput = output
                } else {
                    Debug.p("GTMBarcodeScanner --> Can not add AVCapturePhotoOutput")
                }
            } else {
                let output = AVCaptureStillImageOutput()
                if session.canAddOutput(output) {
                    Debug.p("GTMBarcodeScanner --> add AVCaptureStillImageOutput")
                    session.addOutput(output)
                    _imgOutput = output
                } else {
                    Debug.p("GTMBarcodeScanner --> Can not add AVCaptureStillImageOutput")
                }
            }
        }
        
        // 光强度输出
        let output = AVCaptureVideoDataOutput()
        if session.canAddOutput(output) {
            session.addOutput(output)
            output.setSampleBufferDelegate(self, queue: DispatchQueue.main)
            lightOutput = output
            Debug.p("GTMBarcodeScanner --> add AVCaptureVideoDataOutput")
        } else {
            Debug.p("GTMBarcodeScanner --> Can not add AVCaptureVideoDataOutput")
        }

        // Preview
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        previewLayer?.frame = videoPreView.bounds
        
        videoPreView.layer.insertSublayer(previewLayer!, at: 0)
    }
    
    // MARK: - 扫描控制
    public func start() {
        if !self.session.isRunning {
            Debug.p("GTMBarcodeScanner --> startRunning")
            isBarcodeReconged = false
            session.startRunning()
            session.sessionPreset = AVCaptureSession.Preset.high
            BarcodeScanner.scanView?.animation?.start()
            self.scaleVideo(1)
        }
    }
    public func stop() {
        if session.isRunning {
            Debug.p("GTMBarcodeScanner --> stop")
            session.stopRunning()
            isBarcodeReconged = true
            BarcodeScanner.scanView?.animation?.stop()
        }
    }
    
    public static func create(codeTypes: [AVMetadataObject.ObjectType] = BarcodeUtils.defaultCodeTypes(),view: UIView, prepareTxt: String = "设备准备中...") -> BarcodeScanner {
        // scan view
        scanView = ScanView(frame: view.bounds)
        view.insertSubview(scanView!, at: 0)
        
        scanView?.startDevicePrepare(preparetxt: prepareTxt)
        // create
        let scanner = BarcodeScanner.init(codeTypes: codeTypes, videoPreView: view)
        scanView?.devicePrepared()
        
        return scanner
    }
    
    /// 样式设定
    @discardableResult
    public func makeStyle(_ handler: (_ make: StyleMaker)-> Void) -> BarcodeScanner {
        if let _ = BarcodeScanner.scanView?.style {
            let maker = StyleMaker()
            handler(maker)
            BarcodeScanner.scanView?.setStyle(style: maker.style)
        }
        return self
    }
    @discardableResult
    public func config(_ handler: (_ config: ScannerConfig)-> Void) -> BarcodeScanner {
        handler(config)
        return self
    }

}

// MARK: - 条码扫描输出 delegate
extension BarcodeScanner: AVCaptureMetadataOutputObjectsDelegate, AVCapturePhotoCaptureDelegate {
    
    
    // MARK: AVCaptureMetadataOutputObjectsDelegate
    public func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        Debug.p("GTMBarcodeScanner --> 条码扫描输出 metadataOutput")
        guard !isBarcodeReconged else {
            return
        }
        isBarcodeReconged = true
        
        //识别扫码类型
        for metadata in metadataObjects {
            if metadata.isKind(of: AVMetadataMachineReadableCodeObject.self) {
                if let barcode = metadata as? AVMetadataMachineReadableCodeObject {
                    if var code = barcode.stringValue {
                        let type = barcode.type
                        
                        // 处理 ean13 多一个 0 的问题
                        if type == AVMetadataObject.ObjectType.ean13 {
                            if code.hasPrefix("0") && code.count > 1 {
                                let start = code.index(after: code.startIndex)
                                code = String(code[start...])
                            }
                        }
                        
                        var result = BarcodeResult(code: code, type: type)
                        result.corners = barcode.corners
                        
                        self.result = result
                        isBarcodeReconged = true
                        if isBarcodeReconged {
                            captureImage()
                            
                            if let obj = self.previewLayer!.transformedMetadataObject(for: barcode) as? AVMetadataMachineReadableCodeObject {
                                 autoCloser(obj: obj) // 自动拉近镜头
                            }
                            // 通知条码识别成功
                            self.delegate?.barcodeRecognized(result: result)
                            // 播放声音
                            ScannerSound.sound(forStyle: BarcodeScanner.scanView!.style)
                            self.stop()
                        }
                        return
                    }
                }
            }
        }
        isBarcodeReconged = false
    }
    
    
    // MARK: AVCapturePhotoCaptureDelegate
    
    @available(iOS, introduced: 10.0, deprecated: 11.0, message: "Use -captureOutput:didFinishProcessingPhoto:error: instead.")
    public func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        guard config.isCaputureImage else {
            return
        }
        guard let result = self.result else {
            return
        }
        guard result.image == nil else {
            return
        }

        if let error = error {
            Debug.p("GTMBarcodeScanner --> error occure : \(error.localizedDescription)")
            return
        }

        if  let sampleBuffer = photoSampleBuffer,
            let previewBuffer = previewPhotoSampleBuffer,
            let dataImage =  AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer:  sampleBuffer, previewPhotoSampleBuffer: previewBuffer) {
            print(UIImage(data: dataImage)?.size as Any)

            let dataProvider = CGDataProvider(data: dataImage as CFData)
            let cgImageRef: CGImage! = CGImage(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: .defaultIntent)
            let image = UIImage(cgImage: cgImageRef, scale: 1.0, orientation: UIImage.Orientation.right)
            self.result?.image = image
        } else {
            Debug.p("GTMBarcodeScanner --> error occure when get image")
        }
    }
    @available(iOS 11.0, *)
    public func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let data = photo.fileDataRepresentation() {
            self.result?.image = UIImage(data: data)
        }
    }
    
    
    // MARK: Help methods
    func captureImage() {
        guard config.isCaputureImage else {
            return
        }
        
        guard #available(iOS 10, *) else {
            guard let output = self.imageOutput else {
                return
            }
            if let con = connection(withMediaType: AVMediaType.video, connections: output.connections) {
                output.captureStillImageAsynchronously(from: con) { (buffer, error) in
                    self.stop() // 停止扫描
                    if let imageBuffer = buffer {
                        if let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageBuffer) {
                            let image = UIImage(data: imageData)
                            
                            self.result?.image = image
                        }
                    }
                }
            }
            return //iOS 10 以下系统就直接返回
        }
    }
    
    open func connection(withMediaType type:AVMediaType, connections:[AnyObject]) -> AVCaptureConnection? {
        for con in connections {
            if let connection = con as? AVCaptureConnection {
                for port in connection.inputPorts {
                    if port.mediaType == type {
                        return connection
                    }
                }
            }
        }
        return nil
    }
}


// MARK: - 光强度输出 delegate
extension BarcodeScanner: AVCaptureVideoDataOutputSampleBufferDelegate {

    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard !isLightDetecting else {
            return
        }
        self.isLightDetecting = true
        if let metadata = CMCopyDictionaryOfAttachments(allocator: nil, target: sampleBuffer, attachmentMode: kCMAttachmentMode_ShouldPropagate) as? [String: Any] {
            let exifKey = kCGImagePropertyExifDictionary as String
            if let exifMetadata = metadata[exifKey] as? [String: Any] {
                let brightlessKey = kCGImagePropertyExifBrightnessValue as String
                if let brightlessVal: Double = exifMetadata[brightlessKey] as? Double {
                    var need = (brightlessVal < 0)
                    if isFlashOn {
                        need = true
                    }
//                    Debug.p("GTMBarcodeScanner --> 光强度 brightless value = \(brightlessVal)")
                    // 通知光线变化
                    self.delegate?.lightnessChange(needFlashButton: need)
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) { [weak self] in
            self?.isLightDetecting = false
        }
    }
}

// MARK: - 闪光灯管理
extension BarcodeScanner {
    
    public var isFlashOn: Bool {
        guard let input = deviceInput else {
            return false
        }
        return input.device.torchMode == .on
    }
    
    public func toggleFlashLight() {
        if let input = deviceInput {
            if input.device.torchMode == .on {
                closeFlashLight()
                return
            }
            if input.device.torchMode == .off {
                openFlashLight()
                return
            }
        }
    }
    
    public func openFlashLight() {
        if let input = deviceInput, let vdevice = device, vdevice.hasFlash, vdevice.hasTorch {
            do {
                try input.device.lockForConfiguration()
                input.device.torchMode = .on
                input.device.unlockForConfiguration()
            } catch let error as NSError {
                Debug.p("GTMBarcodeScanner --> device.lockForConfiguration(): \(error)")
            }
        }
    }
    public func closeFlashLight() {
        if let input = deviceInput, let vdevice = device, vdevice.hasFlash, vdevice.hasTorch {
            do {
                try input.device.lockForConfiguration()
                input.device.torchMode = .off
                input.device.unlockForConfiguration()
            } catch let error as NSError {
                Debug.p("GTMBarcodeScanner --> device.lockForConfiguration(): \(error)")
            }
        }
    }
}
