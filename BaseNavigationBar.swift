//
//  BaseNavigationBar.swift
//  GenialTone
//
//  Created by SNDA on 2017/7/4.
//  Copyright © 2017年 SNDA. All rights reserved.
//

import UIKit

var isIPhoneX: Bool {
    let height = UIApplication.shared.statusBarFrame.size.height
    return height > 40
    //return KScreenHeight == 812
}

class BaseNavigationBar: UINavigationBar {

    var navigationItem: UINavigationItem!
    fileprivate var _title: String = ""
    fileprivate var _bottomLine:UIView = UIView() //tabbar底部的线条
    var title: String? {
        set {
            navigationItem.titleView?.removeFromSuperview()
            _title = newValue ?? ""
            let nsTitle = _title as NSString
            let titleLabel = UILabel(frame: nsTitle.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 18)], context: nil))
//            titleLabel.text = newValue
//            titleLabel.font = UIFont.mainFont(ofSize: 18)//UIFont.boldSystemFont(ofSize: 18)
//            titleLabel.textColor = UIColor.gold_txt1
            navigationItem.titleView = titleLabel
        }
        get {
            return _title
        }
    }
    
    var isBottomlineHidden:Bool = false {
        didSet {
            if isBottomlineHidden {
                _bottomLine.isHidden = true
            } else {
                _bottomLine.isHidden = false
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.frame = CGRect(x: 0, y: 0, width:  self.frame.size.width, height: self.frame.size.height)
        for view in self.subviews {
            let viewType = type(of: view)
            let viewClassStr = "\(viewType)"
            //内存泄露 1 byte
//            GTprint("viewClassStr  \(viewClassStr)")
            if viewClassStr.contains("Background") {
                view.frame = self.bounds
            } else  if viewClassStr.contains("ContentView") {
                var frame = view.frame
                //适配的iphoneX
                if #available(iOS 11.0, *) {
                    frame.origin.y = self.safeAreaInsets.top
                } else {
                    frame.origin.y = 20
                }
                frame.size.height = self.bounds.size.height - frame.origin.y
//                frame.size.
                view.frame = frame
            }

        }

    }
    var titleView: UIView? {

        set {
            navigationItem.titleView = newValue
        }
        get {
            return navigationItem.titleView
        }
    }

    var leftBarButtonItem: UIBarButtonItem? {
        set {
            navigationItem.leftBarButtonItem = newValue
        }
        get {
            return navigationItem.leftBarButtonItem
        }
    }

    var leftBarButtonItems: [UIBarButtonItem]? {
        set {
            navigationItem.leftBarButtonItems = newValue
        }
        get {
            return navigationItem.leftBarButtonItems
        }
    }

    var rightBarButtonItem: UIBarButtonItem? {
        set {
            navigationItem.rightBarButtonItem = newValue
        }
        get {
            return navigationItem.rightBarButtonItem
        }
    }

    var rightBarButtonItems: [UIBarButtonItem]? {
        set {
            navigationItem.rightBarButtonItems = newValue
        }
        get {
            return navigationItem.rightBarButtonItems
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)        

        barStyle = .`default`
        let barBgView = UIImage.init(named:isIPhoneX ? "icon_navigation_bar_bg_iphonex" : "icon_navigation_bar_bg")?.resizableImage(withCapInsets: .zero, resizingMode: .stretch)
        setBackgroundImage(barBgView, for: .default)
        contentMode = .scaleToFill
        isTranslucent = false
        //tintColor = UIColor.gold_theme
        shadowImage = UIImage()
        
        
        addSubview(_bottomLine)
        _bottomLine.backgroundColor = UIColor.black
        _bottomLine.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(0.5)
            make.bottom.equalToSuperview()
        }

        navigationItem = UINavigationItem()
        pushItem(navigationItem, animated: false)

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
