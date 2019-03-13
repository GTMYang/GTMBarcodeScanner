//
//  UIViewController+Alert.swift
//  Example
//
//  Created by 骆扬 on 2019/3/8.
//  Copyright © 2019 GTMYang. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func alert(message: String) {
        
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: UIAlertController.Style.alert)
        let alertAction = UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: UIAlertAction.Style.default) { (alertAction) in
        }
        
        alertController.addAction(alertAction)
        
        self.navigationController?.present(alertController, animated: true, completion: nil)
//        present(alertController, animated: true, completion: nil)
    }
}
