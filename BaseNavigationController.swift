//
//  BaseNavigationController.swift
//  GenialTone
//
//  Created by SNDA on 2017/6/21.
//  Copyright © 2017年 SNDA. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController, UIGestureRecognizerDelegate{ ///

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
            navigationBar.prefersLargeTitles = false
        } else {
            // Fallback on earlier versions
        }

        //设置全屏滑动
        let target = self.interactivePopGestureRecognizer?.delegate
        let pan = UIPanGestureRecognizer.init(target: target, action: #selector(handleNavigationTransition(_:)))
        pan.delegate = self
        self.view.addGestureRecognizer(pan)
        self.interactivePopGestureRecognizer?.isEnabled = false
 
        self.isNavigationBarHidden = true
        
        //当设置wbInteractivePopMaxAllowedInitialDistanceToLeftEdge 这个值时, 做边缘不太灵敏, 此处补个边缘滑动手势
        let edgePan = UIScreenEdgePanGestureRecognizer(target: target, action: #selector(handleNavigationTransition(_:)))
        edgePan.delegate = self
        edgePan.edges = .left
        self.view.addGestureRecognizer(edgePan)
        
    }
    
    
    //重置系统侧滑手势
    @objc func handleNavigationTransition(_ gesture: UIPanGestureRecognizer) {

    }
    
    //UIGestureRecognizerDelegate
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        //关闭跟控制器滑动
        if self.children.count == 1 {
            return false
        }
        guard let topViewController = viewControllers.last else {
            return false
        }
        guard !topViewController.wbInteractivePopDisabled else {
            return false
        }
        
        //        self.view.endEditing(true)
        
        //识别为边缘滑动手势
        if let _ = gestureRecognizer as? UIScreenEdgePanGestureRecognizer {
            if topViewController.wbInteractivePopMaxAllowedInitialDistanceToLeftEdge != UIScreen.main.bounds.size.width {
                //self.view.endEditing(true)
                return true
            }
            return false
        }
        
        //识别为全屏滑动手势
        guard let pan = gestureRecognizer as? UIPanGestureRecognizer else {
            return true
        }
        //左滑动是关闭手势
        let firstPoint = pan.translation(in: self.view)
        if firstPoint.x < 0 {
            return false
        }

        let beginLoaction = pan.location(in: self.view)
        if beginLoaction.x > topViewController.wbInteractivePopMaxAllowedInitialDistanceToLeftEdge {
            return false
        }
        
        return true
    }

    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        for vc in viewControllers {
            //EventBus.unsubscribe(vc)
        }
        super.dismiss(animated: flag, completion: completion)
    }

    override func popViewController(animated: Bool) -> UIViewController? {
        if let last = viewControllers.last {
            //EventBus.getDefault().unsubscribe(last)
        }
        return super.popViewController(animated: animated)
    }

    override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        if let index = viewControllers.index(of: viewController) {
            for i in index+1..<viewControllers.count {
                let vc = viewControllers[i]
                //EventBus.getDefault().unsubscribe(vc)
            }
        }
        return super.popToViewController(viewController, animated: animated)
    }

    override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        for i in 1..<viewControllers.count {
            let vc = viewControllers[i]
            //EventBus.getDefault().unsubscribe(vc)
        }
        return super.popToRootViewController(animated: animated)
    }
    
    //是否支持屏幕旋转
    override open var shouldAutorotate: Bool {
        get {
            return topViewController?.shouldAutorotate ?? false
        }
    }
    //支持的屏幕旋转方向
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            //            if !isIPhoneX {
            //                UIApplication.shared.statusBarOrientation = .portrait
            //            }
            return topViewController?.supportedInterfaceOrientations ?? .portrait
        }
    }
    
}
