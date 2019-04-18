//
//  BaseExtensionVCandScoller.swift
//  WB
//
//  Created by wang chao on 2018/12/20.
//  Copyright © 2018 SNDA. All rights reserved.
//

import UIKit

extension UIViewController{
    ///全屏滑动的开关
    public var wbInteractivePopDisabled: Bool {
        get {
            guard let bools = objc_getAssociatedObject(self, RuntimeKey.KEY_wb_interactivePopDisabled!) as? Bool else {
                return false
            }
            return bools
        }
        set {
            objc_setAssociatedObject(self, RuntimeKey.KEY_wb_interactivePopDisabled!, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    ///允许滑动距离左侧边缘 wbInteractivePopMaxAllowedInitialDistanceToLeftEdge 值的时候,才会触发返回.
    ///这个值生效的前提是: 没有关闭全屏滑动, 即wbInteractivePopDisabled == false .
    public var wbInteractivePopMaxAllowedInitialDistanceToLeftEdge: CGFloat {
        get {
            guard let doubleNum = objc_getAssociatedObject(self, RuntimeKey.KEY_wb_interactivePopMaxAllowedInitialDistanceToLeftEdge!) as? CGFloat else {
                return UIScreen.main.bounds.size.width
            }
            return doubleNum
        }
        set {
            objc_setAssociatedObject(self, RuntimeKey.KEY_wb_interactivePopMaxAllowedInitialDistanceToLeftEdge!, newValue, .OBJC_ASSOCIATION_COPY)
        }
    }
    
    
}

fileprivate struct RuntimeKey {
    static let KEY_wb_interactivePopDisabled
        = UnsafeRawPointer(bitPattern: "KEY_wb_interactivePopDisabled".hashValue)
    static let KEY_wb_scrollViewPopGestureRecognizerEnable
        = UnsafeRawPointer(bitPattern: "KEY_wb_scrollViewPopGestureRecognizerEnable".hashValue)
    static let KEY_wb_interactivePopMaxAllowedInitialDistanceToLeftEdge
        = UnsafeRawPointer(bitPattern: "KEY_wb_interactivePopMaxAllowedInitialDistanceToLeftEdge".hashValue)
}

extension UIScrollView: UIGestureRecognizerDelegate {
    
    public var wbScrollViewPopGestureRecognizerEnable: Bool {
        get {
            guard let bools = objc_getAssociatedObject(self, RuntimeKey.KEY_wb_scrollViewPopGestureRecognizerEnable!) as? Bool else {
                return false
            }
            return bools
        }
        set {
            objc_setAssociatedObject(self, RuntimeKey.KEY_wb_scrollViewPopGestureRecognizerEnable!, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    //UIGestureRecognizerDelegate
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.wbScrollViewPopGestureRecognizerEnable, self.contentOffset.x <= 0, let gestureDelegate = otherGestureRecognizer.delegate {
            if gestureDelegate.isKind(of: BaseNavigationController.self) {
                return true
            }
        }
        return false
    }
}
