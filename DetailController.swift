//
//  DetailController.swift
//  animationtest
//
//  Created by wang chao on 2019/4/11.
//  Copyright © 2019 bigfish. All rights reserved.
//

import UIKit

class DetailController: BaseViewController, UITableViewDelegate, UITableViewDataSource, ImageTransitionCDelegate {

    
    var image: UIImage?

    @IBOutlet weak var topImageView: UIImageView!
    
    lazy var tableView: UITableView = {
       let tab = UITableView(frame: UIScreen.main.bounds)
       
        return tab
    }()
    
    var imageHeight: CGFloat = 0
    
    override func viewDidLoad(){
        super.viewDidLoad()
        guard let image = image else{
            return
        }
        navigationBar.isHidden = true
        let tmpHeight: CGFloat = image.size.height * UIScreen.main.bounds.width / image.size.width
        imageHeight = tmpHeight
        topImageView.image = image
        topImageView.frame = CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width, height: tmpHeight))
        view.addSubview(tableView)
        tableView.beginUpdates()
        tableView.contentInset = UIEdgeInsets(top: tmpHeight, left: 0, bottom: 0, right: 0)
        tableView.endUpdates()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 100
        tableView.estimatedRowHeight = 100
        tableView.backgroundColor = .clear
        //tableView.nextResponer = topImageView
        
        topImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapTopImageView)))
        //topImageView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panTopImageView(_:))))
        wbInteractivePopMaxAllowedInitialDistanceToLeftEdge = 0
        //tableView.wbScrollViewPopGestureRecognizerEnable = true
    }
    
    @objc func tapTopImageView(){
        debugPrint("点击顶部图片")
    }
    
    var tmpHeight: CGFloat = 0
    @objc func panTopImageView(_ sender: UIPanGestureRecognizer){
        debugPrint("pan顶部图片")
        
        switch sender.state {
        case .began:
            debugPrint("pan顶部图片")
//            let point = sender.translation(in: topImageView)
//            if point.x <= 5{
//                sender.
//            }
             tmpHeight = tableView.contentOffset.y
        case .changed:
            debugPrint(sender.translation(in: topImageView))
            let point = sender.translation(in: topImageView)
            var realpanDistance = point.y
            if tableView.contentOffset.y <= -imageHeight{
                let t = 1 -  (-imageHeight - tableView.contentOffset.y)/(imageHeight)
                realpanDistance =  point.y*(t > 0 ? t : 0.01)
            }
            
            tableView.contentOffset = CGPoint(x: 0, y: tmpHeight - realpanDistance)
        case .ended:
            debugPrint("pan ended")
            if tableView.contentOffset.y < -imageHeight {
                tableView.setContentOffset(CGPoint(x: 0, y: -imageHeight), animated: true)
            } else {
                tableView.setContentOffset(CGPoint(x: 0, y: tableView.contentOffset.y - sender.velocity(in: topImageView).y*0.3), animated: true)
            }
        case .cancelled:
            debugPrint("pan cancelled")
        default:
            debugPrint("pan顶部图片")
        }
    }
    
    func willTransitionPrepareInfo()->(UIImageView?, String?){
        return (topImageView, nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier:  "cell")
        }
        cell?.textLabel?.text = "\(indexPath.description) cell"
        return cell!
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        debugPrint(scrollView.contentOffset)
        
        if scrollView.contentOffset.y <  -imageHeight {
            let tmpWidth = UIScreen.main.bounds.width*(-scrollView.contentOffset.y)/imageHeight
            topImageView.frame = CGRect(origin: CGPoint(x: -(tmpWidth-UIScreen.main.bounds.width)/2.0, y: 0), size: CGSize(width: tmpWidth, height: -scrollView.contentOffset.y))
        } else {
            topImageView.frame = CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width, height: imageHeight))
        }
    }

}

class TopTransparentTableView: UITableView {
    weak var nextResponer: UIView?
    
    var tapTopTransparent: (()-> Void)?
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        debugPrint(point)
        let view = super.hitTest(point, with: event)
        if point.y <= 0{
        }
        return view
    }
    
}





