//
//  ImageTransition.swift
//  animationtest
//
//  Created by wang chao on 2019/4/17.
//  Copyright © 2019 bigfish. All rights reserved.
//

import UIKit



 /// 转场的from 和 to viewcontroller 都需要遵循的协议
 protocol ImageTransitionCDelegate: class{
    
    /// 专场时 需要获取的信息
    ///
    /// - Returns: (UIImageView?, string?) = (转场的view, view的image的url或本地名字(tovc这个参数不填))
    func willTransitionPrepareInfo()->(UIImageView?, String?)
}


class ImageTransition: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from) else {return}
        guard let toVC = transitionContext.viewController(forKey: .to) else {return}
        let containerView = transitionContext.containerView
        let duration: TimeInterval = transitionDuration(using: transitionContext)
        guard let  fromVCDelegate = fromVC as? ImageTransitionCDelegate else {
            return
        }
        let fromInfo = fromVCDelegate.willTransitionPrepareInfo()
        guard let fromVCImageView = fromInfo.0 else {
            return
        }
        guard let  toVCDelegate = toVC as? ImageTransitionCDelegate else {
            return
        }
        let toInfo = toVCDelegate.willTransitionPrepareInfo()
        guard let toVCImageView = toInfo.0 else {
            return
        }
        
        let imageView = UIImageView()
        if let urlStr = fromInfo.1, urlStr.contains("http"){
            print("TODO: kingfish 设置图片")
        } else {
            imageView.image = fromVCImageView.image
        }
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.frame = (containerView.convert(fromVCImageView.frame, from: fromVCImageView.superview))
        toVC.view.frame = transitionContext.finalFrame(for: toVC)
        toVC.view.alpha = 0
        toVCImageView.isHidden = true
        containerView.addSubview(toVC.view)
        containerView.addSubview(imageView)
        fromVC.tabBarController?.tabBar.isHidden = true
        let newframe: CGRect = (containerView.convert(toVCImageView.frame, from: toVC.view))
        UIView.animate(withDuration: duration, animations: {
            toVC.view.alpha = 1.0
            imageView.frame = newframe
        }) { (_ finished: Bool) in
            toVCImageView.isHidden = false
            fromVC.tabBarController?.tabBar.isHidden = false
            imageView.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
    }
}
