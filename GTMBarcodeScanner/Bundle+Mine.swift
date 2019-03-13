//
//  Bundle+Me.swift
//  GTMBarcodeScanner
//
//  Created by 骆扬 on 2019/3/7.
//  Copyright © 2019 GTMYang. All rights reserved.
//

import Foundation

extension Bundle {
    static var mine: Bundle {
        return Bundle(for: BarcodeScanner.self)
    }
}
