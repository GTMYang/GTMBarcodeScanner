//
//  Button+Show.swift
//  Example
//
//  Created by 骆扬 on 2019/3/8.
//  Copyright © 2019 GTMYang. All rights reserved.
//

import UIKit

extension UIButton {
    
    var isShow: Bool {
        get {
            return !isHidden
        }
        set {
            isHidden = !newValue
        }
    }
}
