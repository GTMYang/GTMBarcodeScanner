//
//  ScannerConfig.swift
//  GTMBarcodeScanner
//
//  Created by 骆扬 on 2019/3/4.
//  Copyright © 2019 GTMYang. All rights reserved.
//

import Foundation

public struct ScannerConfig {
    /// 当距离太远时是否自动拉近，默认：true
    var isAutoCloser: Bool = true
    /// 是否在结果中返回识别时的图片，默认：false
    var isCaputureImage: Bool = true
    /// 主要控制调试信息的打印
    var isPrintLog: Bool = true
    static var shared = ScannerConfig()
    
    init() { }
    
    @discardableResult
    public mutating func autoCloser(_ closer: Bool) -> ScannerConfig {
        isAutoCloser = closer
        return self
    }
    @discardableResult
    public mutating func caputureImage(_ caputure: Bool) -> ScannerConfig {
        isCaputureImage = caputure
        return self
    }
    @discardableResult
    public mutating func printLog(_ print: Bool) -> ScannerConfig {
        isPrintLog = print
        return self
    }
}
protocol ConfigUser {
    var config: ScannerConfig { get }
}

extension ConfigUser {
    var config: ScannerConfig {
        return ScannerConfig.shared
    }
}

extension BarcodeScanner: ConfigUser { }
