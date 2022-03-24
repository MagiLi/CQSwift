//
//  CQCycleController.swift
//  CQSwift
//
//  Created by llbt2019 on 2022/2/17.
//  Copyright © 2022 李超群. All rights reserved.
//

import UIKit

enum DragDirection:Int { // 拖动方向
    case right = 0 // 从右边往左边拖动 ←←←←
    case left = 1 // 从左边往右边拖动 →→→→
}

class CQCycleController: UIViewController, UIScrollViewDelegate {

    let screenW = UIScreen.main.bounds.width
    let scrollViewH:CGFloat = 168.0//
    let leftSmallH:CGFloat = 62.0 //
    let rightSmallH:CGFloat = 102.0 //  
    var leftTotalDetalH:CGFloat! // 大小视图最大的高度差
    var rightTotalDetalH:CGFloat! // 大小视图最大的高度差
    let margin:CGFloat = 20.0 // 中间视图距离两边的距离
    // 左边 缩小的view露出的尾部距离 5.0 （该值必须小于margin）
    let leftViewFooter:CGFloat = 5.0
    // 右边 缩小的view露出的头部距离 5.0 （该值必须小于margin）
    let rightViewHeader:CGFloat = 15.0
    var contentWidth:CGFloat!
    
    var currentIndex: Int = 1 {
        didSet {
            scrollView.setContentOffset(CGPoint(x: screenW, y: 0.0), animated: false)
            self.resetDataForSubViews()
        }
    }
    
    var isDragging:Bool = false // 是否正在拖动
    var isDecelerating:Bool = false // 是否正在减速
    var dragDirection:DragDirection? // 拖动方向
    
    var beginDraggingX:CGFloat = 0.0 // 开始拖动时的偏移量
    var endDraggingX:CGFloat = 0.0 // 拖动结束时的偏移量
    var endDeceleratingX:CGFloat = 0.0 // 滚动结束时的偏移量（拖动结束后获得的值）

    //MARK: UIScrollViewDelegate
    //MARK: 执行顺序：0 (拖动 将要开始)
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        debugPrint("WillBeginDragging-ontentOffset.x: %f", scrollView.contentOffset.x)
        self.isDragging = true
        self.beginDraggingX = scrollView.contentOffset.x
    }
    //MARK: 执行顺序：1 (滚动)
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        debugPrint("DidScroll-ontentOffset.x: %f", scrollView.contentOffset.x)
        
//        var value:CGFloat
//        if scrollView.contentOffset.x <= 0 { // 左边界
//            value = 0.0
//        } else if scrollView.contentOffset.x >= self.contentWidth { // 右边界
//            value = CGFloat(self.colors.count - 1)
//        } else {
//            value = scrollView.contentOffset.x / screenW
//        }
        if self.isDragging {
            if self.beginDraggingX <= scrollView.contentOffset.x {
                self.dragDirection = .right
            } else if self.beginDraggingX > scrollView.contentOffset.x {
                self.dragDirection = .left
            }
        }
        
        // 移动的距离
        // 从右边往左边拖动 ←←←← ，dragMoveD > 0
        // 从左边往右边拖动 →→→→ ，dragMoveD < 0
        let dragMoveD = fabsf(Float(scrollView.contentOffset.x - self.beginDraggingX))
        // 子view需要移动的最大距离
        // 注意⚠️：scrollView滚动时，子view相对于scrollView并没有移动。
        // 所以，需要手动移动子View，保证可以露出rightViewHeader/leftViewFooter拘留
        let leftViewMoveX = self.margin + self.leftViewFooter
        let rightViewMoveX = self.margin + self.rightViewHeader
        let leftD_H = screenW - leftViewMoveX // 变为左边视图时，高度变化的最大距离
        let leftScale = CGFloat(dragMoveD) / leftD_H
        let rightD_H = screenW - rightViewMoveX // 变为右边视图时，高度变化的最大距离
        let rightScale = CGFloat(dragMoveD) / rightD_H
        
        var rightDetalH:CGFloat = 0.0 // 变为右边视图时，高度变化的距离
        var leftDetalH:CGFloat = 0.0 // 变为左边视图时，高度变化的距离
        var rightDetalX:CGFloat = 0.0
        var leftDetalX:CGFloat = 0.0
        if rightScale > 1.0 {
            rightDetalH = self.rightTotalDetalH
            leftDetalH = self.leftTotalDetalH
            
            rightDetalX = rightViewMoveX
            leftDetalX = leftViewMoveX
        } else {
            rightDetalH = self.rightTotalDetalH * rightScale
            leftDetalH = self.leftTotalDetalH * leftScale
            
            rightDetalX = rightViewMoveX * rightScale
            leftDetalX = leftViewMoveX * leftScale
        }
        self.changeFrameForSubViews(leftDetalH, leftDetalX, rightDetalH, rightDetalX)
        
        
//        // 高度变化参考的单位距离
//        let d_H = screenW - rightViewMoveX
//        let scaleH = CGFloat(dragMoveD) / d_H
//        var detalH:CGFloat = 0.0
//        if scaleH > 1.0 {
//            detalH = self.totalDetalH
//        } else {
//            detalH = self.totalDetalH * scaleH
//        }
//        // x的位移差25.0, 参考的单位距离
//        let d_X = screenW
//        let scaleX = CGFloat(dragMoveD) / d_X
//        var detalX:CGFloat = 0.0
//        if scaleX > 1.0 {
//            detalX = rightViewMoveX
//        } else {
//            detalX = rightViewMoveX * scaleX
//        }
//        self.changeFrameForSubViews(detalH, detalX)
    }
    
    //MARK: 执行顺序：2 (拖动 结束)
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        debugPrint("DidEndDragging-ontentOffset.x: %f", scrollView.contentOffset.x)
        self.endDraggingX = scrollView.contentOffset.x
        self.isDragging = false
    }
    //MARK: 执行顺序：3 (减速 将要开始)
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        // 减速结束前需要禁止拖动 （避免拖动过于频繁）
        self.scrollView.panGestureRecognizer.isEnabled = false
        self.isDecelerating = true
    }
    //MARK: 执行顺序：4 (减速 结束)
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        debugPrint("DidEndDecelerating-ontentOffset.x: %f", scrollView.contentOffset.x)
        
        self.endDeceleratingX = scrollView.contentOffset.x
        
        if self.dragDirection == .right { // 从右边往左边拖动 ←←←←
            // 拖动结束时的contentOffset.x 小于 当前contentOffset.x
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
        self.isDecelerating = false
        // 减速结束时需要开启拖动
        self.scrollView.panGestureRecognizer.isEnabled = true
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
    //MARK: changeFrameForSubViews
    fileprivate func changeFrameForSubViews( _ leftDetalH:CGFloat,_ leftDetalX:CGFloat, _ rightDetalH:CGFloat, _ rightDetalX:CGFloat) {
        self.scrollView.subviews.forEach { (view) in
            if let lab = view as? UILabel {
                if lab.tag == 0 { // 左边视图
                    let leftSmallW = screenW - margin * 2.0
                    var leftSmallH = self.leftSmallH
                    var leftSmallX = margin*2 + self.leftViewFooter
                    var leftSmallY = self.leftTotalDetalH * 0.5
                    if self.dragDirection == .left {
                        leftSmallX = leftSmallX - leftDetalX
                        leftSmallH = leftSmallH + leftDetalH
                        leftSmallY = (scrollViewH - leftSmallH) * 0.5
                    }
                    lab.frame = CGRect(x: leftSmallX, y: leftSmallY, width: leftSmallW, height: leftSmallH)
                } else if lab.tag == 1 { // 中间视图
                    let centerW = screenW - margin * 2.0
                    var centerH = scrollViewH
                    var centerX = screenW + margin
                    if self.dragDirection == .left {
                        centerX = centerX - rightDetalX
                        centerH = centerH - rightDetalH
                    } else if self.dragDirection == .right {
                        centerX = centerX + leftDetalX
                        centerH = centerH - leftDetalH
                    }
                    let centerY = (scrollViewH - centerH) * 0.5
                    lab.frame = CGRect(x: centerX, y: centerY, width: centerW, height: centerH)
                } else if lab.tag == 2 { // 右边视图
                    let rightSmallW = screenW - margin * 2.0
                    var rightSmallH = self.rightSmallH
                    var rightSmallX = screenW*2.0 - self.rightViewHeader
                    var rightSmallY = self.rightTotalDetalH * 0.5
                    if self.dragDirection == .right {
                        rightSmallX = rightSmallX + rightDetalX
                        rightSmallH = rightSmallH + rightDetalH
                        rightSmallY = (scrollViewH - rightSmallH) * 0.5
                    }
                    lab.frame = CGRect(x: rightSmallX, y: rightSmallY, width: rightSmallW, height: rightSmallH)
                }
            }
        }
    }
    //MARK: 重置view的frame
    fileprivate func resetFrameForSubViews() {
        
        self.scrollView.subviews.forEach { (view) in
            if let lab = view as? UILabel {
                if lab.tag == 0 {
                    let leftSmallW = screenW - margin * 2.0
                    let leftSmallX = margin*2 + self.leftViewFooter
                    let leftSmallY = self.leftTotalDetalH * 0.5
                    lab.frame = CGRect(x: leftSmallX, y: leftSmallY, width: leftSmallW, height: self.leftSmallH)
                } else if lab.tag == 1 {
                    let centerX = screenW + margin
                    let centerW = screenW - margin * 2.0
                    lab.frame = CGRect(x: centerX, y: 0.0, width: centerW, height: scrollViewH)
                } else if lab.tag == 2 {
                    let rightSmallW = screenW - margin * 2.0
                    let rightSmallX = screenW*2.0 - self.rightViewHeader
                    let rightSmallY = self.rightTotalDetalH * 0.5
                    lab.frame = CGRect(x: rightSmallX, y: rightSmallY, width: rightSmallW, height: self.rightSmallH)
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.contentWidth = screenW * 3.0
        self.leftTotalDetalH = scrollViewH - self.leftSmallH
        self.rightTotalDetalH = scrollViewH - self.rightSmallH
        self.view.addSubview(self.scrollView)
        for i in 0..<3 {
            let view = UILabel()
            view.backgroundColor = self.colors[i]
            view.tag = i
            view.text = "\(i)"
            view.font = UIFont.boldSystemFont(ofSize: 20.0)
            self.scrollView.addSubview(view)
        }
        
        scrollView.setContentOffset(CGPoint(x: screenW, y: 0.0), animated: false)
        self.resetFrameForSubViews()
    }
   
    
    lazy var colors: [UIColor] = [.red, .green, .blue, .cyan, .yellow, .orange]
    
    lazy var scrollView: CQCycleView = {
        let view = CQCycleView(frame: CGRect(x: 0.0, y: 100.0, width: screenW, height: scrollViewH))
        view.contentSize = CGSize(width: self.contentWidth, height: 0.0)
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.isPagingEnabled = true
        view.bounces = false
        view.delegate = self
        view.backgroundColor = .lightGray
        return view
    }()

}
