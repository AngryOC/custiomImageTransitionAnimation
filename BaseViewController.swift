//
//  BaseViewController.swift
//  GenialTone
//
//  Created by SNDA on 2017/6/21.
//  Copyright © 2017年 SNDA. All rights reserved.
//

import UIKit
import SnapKit

class BaseViewController: UIViewController {

    var navigationBar: BaseNavigationBar!
    var viewModel: NSObject?

    var isNeedHidden:Bool = false {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        //ios8.x下Controller没能与xib关联 需要手动关联(ios9及后续版本会自动找到对应的xib不需要重写该方法)
        //内存泄露 1Byte 
        let classString = String(describing: type(of: self))
        if Bundle.main.path(forResource: classString, ofType: "nib") == nil {
            super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        } else {
            super.init(nibName: nibNameOrNil ?? classString, bundle: nibBundleOrNil)
        }
        
        hidesBottomBarWhenPushed = true
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }

    //适配的iphoneX
    @available(iOS 11.0, *)
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        navigationBar.snp.updateConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(0)
            make.height.equalTo(self.view.safeAreaInsets.top+44)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        edgesForExtendedLayout = .top
        extendedLayoutIncludesOpaqueBars = true
            if #available(iOS 11.0, *) {
                UIScrollView.appearance().contentInsetAdjustmentBehavior = .never

            } else {
                automaticallyAdjustsScrollViewInsets = false
            }
        //添加自定义导航
        navigationBar = BaseNavigationBar(frame: .zero)
        view.addSubview(navigationBar)
        navigationBar.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(64)
            make.top.equalToSuperview()
        }
        //添加统一返回按钮
        if self.navigationController != nil && (self.navigationController?.children.count)! >= 2 {
            navigationBar.leftBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "icon_navigation_btn_back_nor"), style: .plain, target: self, action: #selector(backButtonClicked(_:)))
        }
        // 构造UI
        buildView()
  
        // 自定义导航栏前置
        view.bringSubviewToFront(self.navigationBar)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }



    func initViewModel() {
        var vcClass: AnyClass? = type(of: self)
        repeat {
            let viewModelClass: AnyClass? = NSClassFromString(NSStringFromClass(vcClass!) + "Model")
            viewModel = (viewModelClass as? NSObject.Type)?.init()
            vcClass = vcClass!.superclass()
        } while viewModel == nil && vcClass != nil

    }


    
    

    


    func buildView() {

    }
    

    deinit {
        /// 移除通知
        NotificationCenter.default.removeObserver(self)
    }

    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
    }

    //action
    @objc func backButtonClicked(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    



    
}

