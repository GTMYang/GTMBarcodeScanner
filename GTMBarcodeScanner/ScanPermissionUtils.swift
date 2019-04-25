//
//  ScanPermissionUtils.swift
//  GTMBarcodeScanner
//
//  Created by 骆扬 on 2019/3/4.
//  Copyright © 2019 GTMYang. All rights reserved.
//

import Foundation
import Photos

class ScanPermissionUtils {
    
    //MARK: ----获取相册权限
    static func authorizePhotoWith(comletion:@escaping (Bool)->Void )
    {
        let granted = PHPhotoLibrary.authorizationStatus()
        switch granted {
        case PHAuthorizationStatus.authorized:
            comletion(true)
        case PHAuthorizationStatus.denied,PHAuthorizationStatus.restricted:
            comletion(false)
        case PHAuthorizationStatus.notDetermined:
            PHPhotoLibrary.requestAuthorization({ (status) in
                DispatchQueue.main.async {
                    comletion(status == PHAuthorizationStatus.authorized ? true:false)
                }
            })
        @unknown default:
            comletion(false)
        }
    }
    
    //MARK: ---相机权限
    static func authorizeCameraWith(comletion:@escaping (Bool)->Void )
    {
        let granted = AVCaptureDevice.authorizationStatus(for: AVMediaType.video);
        
        switch granted {
        case .authorized:
            comletion(true)
            break;
        case .denied:
            comletion(false)
            break;
        case .restricted:
            comletion(false)
            break;
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted:Bool) in
                DispatchQueue.main.async {
                    comletion(granted)
                }
            })
        @unknown default:
            comletion(false)
        }
    }
    
    //MARK:跳转到APP系统设置权限界面
    static func jumpToSystemPrivacySetting()
    {
        let appSetting = URL(string:UIApplication.openSettingsURLString)
        
        if appSetting != nil
        {
            if #available(iOS 10, *) {
                UIApplication.shared.open(appSetting!, options: [:], completionHandler: nil)
            }
            else{
                UIApplication.shared.openURL(appSetting!)
            }
        }
    }
}
