//
//  CodeViewController.swift
//  Example
//
//  Created by 骆扬 on 2019/3/12.
//  Copyright © 2019 GTMYang. All rights reserved.
//

import UIKit
import GTMBarcodeScanner

class CodeViewController: UIViewController {
    @IBOutlet weak var qrImageV: UIImageView!
    @IBOutlet weak var code128ImageV: UIImageView!
    @IBOutlet weak var withLogoCodeImageV: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    
    func setup() {
        let vs = [qrImageV, code128ImageV, withLogoCodeImageV]
        for v in vs {
            v?.contentMode = .center
        }
       
        
        
        let color = UIColor.init(red: 255/255, green: 157/255, blue: 0/255, alpha: 1) // 橙色
        let size = CGSize(width: 150, height: 150)
        let logo = UIImage(named: "logo")
        
        let codeImage = BarcodeUtils.create(.qr,"238923892389829", size, color, .white)
        qrImageV.image = codeImage
        
        code128ImageV.image = BarcodeUtils.createCode128("12345678", CGSize(width: 200, height: 80))
        
        withLogoCodeImageV.image = BarcodeUtils.create(.qr, "238923892389829", size, withLogo: logo!, andLogoSize: CGSize(width: 50, height: 50))
    }


}
