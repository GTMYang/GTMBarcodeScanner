//
//  DebugUtils.swift
//  GTMBarcodeScanner
//
//  Created by 骆扬 on 2019/3/4.
//  Copyright © 2019 GTMYang. All rights reserved.
//

import UIKit

class DebugUtils {

    static func p(_ item: @autoclosure () -> Any) {
        if ScannerConfig.shared.isPrintLog {
            Swift.print(item())
        }
    }
    
}
