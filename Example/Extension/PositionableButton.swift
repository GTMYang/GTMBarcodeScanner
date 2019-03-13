//
//  PositionableButton.swift
//
//
//  Created by 骆扬 on 2017/12/11.
//  Copyright © 2017年 LY. All rights reserved.
//

import UIKit

@IBDesignable
class PositionableButton: UIButton {
    
    // top = 0; right = 1; bottom = 2; left = 3;
    @IBInspectable var position: Int = 0 {
        didSet {
            self.doLayout()
        }
    }
    @IBInspectable var splitSpace: CGFloat = 0 {
        didSet {
            self.doLayout()
        }
    }
    @IBInspectable var positionImage: UIImage? {
        didSet {
            self.setImage(positionImage, for: .normal)
            // self.setImage(positionImage, for: .selected)
            // set position
            self.doLayout()
        }
    }
    @IBInspectable var positionTitle: String? {
        didSet {
            self.setTitle(positionTitle, for: .normal)
            // set position
            self.doLayout()
        }
    }
    @IBInspectable var isTitleLineBreak: Bool = false {
        didSet {
            titleLabel?.lineBreakMode = .byWordWrapping
            titleLabel?.textAlignment = .center
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.doLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.doLayout()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        doLayout()
    }
    
    func doLayout() {
        if let image = self.currentImage {
            guard let titLabel = self.titleLabel else {
                return
            }
            let imageSize = image.size
            let titleSize = titLabel.intrinsicContentSize
            let ajust = splitSpace / 2
            switch (position) {
            case 0: // 图片居上
                self.imageEdgeInsets = UIEdgeInsets(top: -titleSize.height - ajust,
                                                    left: 0,
                                                    bottom: 0,
                                                    right: -titleSize.width)
                self.titleEdgeInsets = UIEdgeInsets(top: ajust,
                                                    left: -imageSize.width,
                                                    bottom: -imageSize.height,
                                                    right: 0)
            case 1: // 图片居右
                self.titleEdgeInsets = UIEdgeInsets(top: 0,
                                                    left: -imageSize.width*2 - ajust,
                                                    bottom: 0,
                                                    right: 0)
                self.imageEdgeInsets = UIEdgeInsets(top: 0,
                                                    left: ajust,
                                                    bottom: 0,
                                                    right: -titleSize.width*2)
            case 2: // 图片居下
                self.imageEdgeInsets = UIEdgeInsets(top: ajust + titleSize.height,
                                                    left: 0,
                                                    bottom: 0,
                                                    right: -titleSize.width)
                self.titleEdgeInsets = UIEdgeInsets(top: -imageSize.height - ajust,
                                                    left: -imageSize.width,
                                                    bottom: 0,
                                                    right: 0)
            case 3: // 图片居左
                self.titleEdgeInsets = UIEdgeInsets(top: 0, left: ajust, bottom: 0, right: 0)
                self.imageEdgeInsets = UIEdgeInsets(top: 0, left: -ajust, bottom: 0, right: 0)
            default:
                break
            }
        }
    }
    
}
