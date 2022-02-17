//
//  CQCycleController.swift
//  CQSwift
//
//  Created by llbt2019 on 2022/2/17.
//  Copyright © 2022 李超群. All rights reserved.
//

import UIKit

enum DragDirection:Int { // 拖动方向
    case none = 0 // 没有拖动
    case right = 1 // 从右边往左边拖动 ←←←←
    case left = 2 // 从左边往右边拖动 →→→→
}

class CQCycleController: UIViewController, UIScrollViewDelegate {

    let screenW = UIScreen.main.bounds.width
    let scrollViewH:CGFloat = 68.0
    let smallH:CGFloat = 62.0
    let totalDetalH:CGFloat！
    let margin:CGFloat = 20.0
    var contentWidth:CGFloat!
    
    var currentIndex: Int = 1 {
        didSet {
            scrollView.setContentOffset(CGPoint(x: screenW, y: 0.0), animated: false)
            self.resetDataForSubViews()
        }
    }
    
    var dragDirection:DragDirection = .none // 拖动方向
    var isDragging = false // 是否正在拖动
    
    var beginDraggingX:CGFloat = 0.0 // 开始拖动时的偏移量
    var endDraggingX:CGFloat = 0.0 // 拖动结束时的偏移量
    var endDeceleratingX:CGFloat = 0.0 // 滚动结束时的偏移量（拖动结束后获得的值）
    
    //MARK:UIScrollViewDelegate
    // 执行顺序：0
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        debugPrint("DidScroll-ontentOffset.x: %f", scrollView.contentOffset.x)
        var value:CGFloat
        if scrollView.contentOffset.x <= 0 { // 左边界
            value = 0.0
        } else if scrollView.contentOffset.x >= self.contentWidth { // 右边界
            value = CGFloat(self.colors.count - 1)
        } else {
            value = scrollView.contentOffset.x / screenW
        }
//        if self.isDragging {
//            let newX = scrollView.contentOffset.x
//        }
//        self.pageControl.changeCurrentImageViewValue(value)
//        print(scrollView.contentOffset.x)
        
        // 移动的距离
        let moveD = fabsf(Float(self.beginDraggingX - scrollView.contentOffset.x))
        // 单位距离
        let d = screenW - 25.0
        let scaleH = CGFloat(moveD) / d
        var detalH:CGFloat!
        if scaleH > 1.0 {
            detalH = self.totalDetalH
        } else {
            detalH = self.totalDetalH * 6.0
        }
        
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        debugPrint("WillBeginDragging-ontentOffset.x: %f", scrollView.contentOffset.x)
        self.isDragging = true
        self.beginDraggingX = scrollView.contentOffset.x
    }
    // 执行顺序：1
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        debugPrint("DidEndDragging-ontentOffset.x: %f", scrollView.contentOffset.x)
        self.endDraggingX = scrollView.contentOffset.x
        self.isDragging = false
        if self.beginDraggingX < self.endDraggingX {
            self.dragDirection = .right
        } else if self.beginDraggingX > self.endDraggingX {
            self.dragDirection = .left
        } else {
            self.dragDirection = .none
        }
    }
    // 执行顺序：2
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        let index = ceilf(Float(scrollView.contentOffset.x / ScreenWidth))
//        self.pageControl.currentIndex = Int(index)
        debugPrint("DidEndDecelerating-ontentOffset.x: %f", scrollView.contentOffset.x)
        
        self.endDeceleratingX = scrollView.contentOffset.x
        
        if self.dragDirection == .right { // 从右边往左边拖动 ←←←←
            if self.endDraggingX < self.endDeceleratingX {
                if self.currentIndex >= self.colors.count - 1 {
                    self.currentIndex = 0
                } else {
                    self.currentIndex += 1
                }
            }
        } else if self.dragDirection == .left { // 从左边往右边拖动 →→→→
            if self.endDraggingX > self.endDeceleratingX {
                if self.currentIndex <= 0 {
                    self.currentIndex = self.colors.count - 1
                } else {
                    self.currentIndex -= 1
                }
            }
        }
    }
    //MARK: 重置view的数据
    fileprivate func resetDataForSubViews() {
        self.scrollView.subviews.forEach { (view) in
            if let lab = view as? UILabel {
                if lab.tag == 0 {
                    if self.currentIndex <= 0 {
                        lab.backgroundColor = self.colors[self.colors.count - 1]
                        lab.text = "\(self.colors.count - 1)"
                    } else {
                        lab.backgroundColor = self.colors[self.currentIndex - 1]
                        lab.text = "\(self.currentIndex - 1)"
                    }
                } else if lab.tag == 1 {
                    lab.backgroundColor = self.colors[self.currentIndex]
                    lab.text = "\(self.currentIndex)"
                } else if lab.tag == 2 {
                    if self.currentIndex >= self.colors.count - 1 {
                        lab.backgroundColor = self.colors[0]
                        lab.text = "\(0)"
                    } else {
                        lab.backgroundColor = self.colors[self.currentIndex + 1]
                        lab.text = "\(self.currentIndex + 1)"
                    }
                }
            }
        }
    }
    //MARK: 重置view的frame
    fileprivate func resetFrameForSubViews() {
        let normalW = screenW - margin * 2.0
        let smallW = normalW
        let smallY = self.totalDetalH * 0.5
        self.scrollView.subviews.forEach { (view) in
            if let lab = view as? UILabel {
                if lab.tag == 0 {
                    let smallX = margin*2 + 5.0
                    lab.frame = CGRect(x: smallX, y: smallY, width: smallW, height: self.smallH)
                } else if lab.tag == 1 {
                    let normalX = screenW + margin
                    lab.frame = CGRect(x: normalX, y: 0.0, width: normalW, height: scrollViewH)
                } else if lab.tag == 2 {
                    let smallX = screenW*2.0 - 5.0
                    lab.frame = CGRect(x: smallX, y: smallY, width: smallW, height: self.smallH)
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.contentWidth = screenW * 3.0
        self.totalDetalH = scrollViewH - self.smallH
        self.view.addSubview(self.scrollView)
//        let viewW = screenW - margin * 2.0
//        let viewH = scrollViewH
        for i in 0..<3 {
            let view = UILabel()
            view.backgroundColor = self.colors[i]
            view.tag = i
            view.text = "\(i)"
            view.font = UIFont.boldSystemFont(ofSize: 20.0)
            self.scrollView.addSubview(view)
        }
        self.resetFrameForSubViews()
        scrollView.setContentOffset(CGPoint(x: screenW, y: 0.0), animated: false)
    }
   
    
    lazy var colors: [UIColor] = [.red, .green, .blue, .cyan, .yellow, .orange]
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView(frame: CGRect(x: 0.0, y: 100.0, width: screenW, height: scrollViewH))
        view.contentSize = CGSize(width: self.contentWidth, height: 0.0)
        view.showsVerticalScrollIndicator = false;
        view.showsHorizontalScrollIndicator = false;
        view.isPagingEnabled = true
        view.bounces = false;
        view.delegate = self;
        view.backgroundColor = .lightGray
        return view
    }()

}
