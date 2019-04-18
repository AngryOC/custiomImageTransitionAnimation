## custiomImageTransitionAnimation
转场过程中图片过度, 过渡之后tableView下拉图片放大  
  

###### 转场动画
```swift
//核心是线面这个类
class ImageTransition: NSObject, UIViewControllerAnimatedTransitioning

// 转场的from 和 to viewcontroller 都需要遵循的协议
 protocol ImageTransitionCDelegate: class{
    func willTransitionPrepareInfo()->(UIImageView?, String?)
}

//demo: 中 fromvc -> ListController
//         toVC ->  DetailController

//ListController.swift
//提供fromvc 需要过度的动画控件 和 图片URL
func willTransitionPrepareInfo()->(UIImageView?, String?){
    if let selectRow = tableView.indexPathForSelectedRow  {
        if let cell = tableView.cellForRow(at: selectRow) as? ListCell{
            return (cell.imageV, cell.model)
        }
    }
    return (nil, nil)
}

//DetailController.swift
// 提供 动画控件 目标位置
func willTransitionPrepareInfo()->(UIImageView?, String?){
        return (topImageView, nil)
    }
```  

######  图片 下拉放
```swift
//DetailController.swift
 func scrollViewDidScroll(_ scrollView: UIScrollView) {
    debugPrint(scrollView.contentOffset)
    if scrollView.contentOffset.y <  -imageHeight {
        let tmpWidth = UIScreen.main.bounds.width*(-scrollView.contentOffset.y)/imageHeight
        topImageView.frame = CGRect(origin: CGPoint(x: -(tmpWidth-UIScreen.main.bounds.width)/2.0, y: 0), size: CGSize(width: tmpWidth, height: -scrollView.contentOffset.y))
    } else {
        topImageView.frame = CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width, height: imageHeight))
    }
}

```
![1](https://github.com/AngryOC/custiomImageTransitionAnimation/blob/master/121.jpeg)
![2](https://github.com/AngryOC/custiomImageTransitionAnimation/blob/master/122.jpeg)
[效果图](https://github.com/AngryOC/custiomImageTransitionAnimation/blob/master/demo.MOV)
