//
//  ScanAnimation.swift
//  GTMBarcodeScanner
//
//  Created by 骆扬 on 2019/3/5.
//  Copyright © 2019 GTMYang. All rights reserved.
//

import UIKit

public protocol ScanAnimation: class {
    func start()
    func stop()
}

class LineMoveAnimation: ScanAnimation {
    var begin: CGFloat
    var end: CGFloat
    weak var view: UIView?
    var isAnimating = false
    var duration: TimeInterval
    
    init(beginY: CGFloat, endY: CGFloat, animationV: UIView, duration: TimeInterval) {
        begin = beginY
        end = endY
        view = animationV
        self.duration = duration
    }
    
    func start() {
        guard !isAnimating else {
            return
        }
        isAnimating = true
        moving()
    }
    
    func stop() {
        view?.isHidden = true
        isAnimating = false
    }
    
    func moving() {
        guard var f = view?.frame else {
            return
        }
        f.origin.y = begin
        view?.frame = f
        UIView.animate(withDuration: 3, animations: { [weak self] in
            guard let me = self else {
                return
            }
            f.origin.y = me.end
            me.view?.frame = f
        }) { [weak self] (finish) in
            guard let me = self else {
                return
            }
            if me.isAnimating {
                me.moving()
            }
        }
    }
}

class GridMoveAnimation: ScanAnimation {
    var begin: CGFloat
    var end: CGFloat
    weak var view: UIView?
    var isAnimating = false
    var duration: TimeInterval
    
    init(beginHeight: CGFloat, endHeight: CGFloat, animationV: UIView, duration: TimeInterval) {
        begin = beginHeight
        end = endHeight
        view = animationV
        self.duration = duration
    }
    
    func start() {
        guard !isAnimating else {
            return
        }
        isAnimating = true
        moving()
    }
    
    func stop() {
        view?.isHidden = true
        isAnimating = false
    }
    
    func moving() {
        guard var f = view?.frame else {
            return
        }
        f.size.height = begin
        view?.frame = f
        UIView.animate(withDuration: 2, animations: { [weak self] in
            guard let me = self else {
                return
            }
            f.size.height = me.end
            me.view?.frame = f
        }) { [weak self] (finish) in
            guard let me = self else {
                return
            }
            if me.isAnimating {
                me.moving()
            }
        }
    }
}

