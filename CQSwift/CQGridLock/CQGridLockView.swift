//
//  CQGridLockView.swift
//  CQSwift
//
//  Created by llbt2019 on 2021/9/28.
//  Copyright © 2021 李超群. All rights reserved.
//

import UIKit


enum GridUnlockResultType:Int {
    case unknow = 0
    case failed = 1
    case success = 2
}

protocol CQGridLockViewDelegate:NSObjectProtocol {
    func panFinished(_ lockView:CQGridLockView, _ passwordStr:String)
}

class CQGridLockView: UIView {
    weak var delegate:CQGridLockViewDelegate?
    fileprivate var resultType:GridUnlockResultType = .unknow // 解锁结果
    fileprivate var panFinished = false // 拖拽完成
    fileprivate var currentPoint:CGPoint?
    
    //MARK: panGestureRecognizer
    @objc func panGestureRecognizer(_ sender:UIPanGestureRecognizer) {
        if self.panFinished { return }
        if sender.state == .cancelled || sender.state == .failed {
            self.clearPanGesture()
            return
        }
        self.currentPoint = sender.location(in: self)
        for subView in self.subviews {
            if let currentImgView = subView as? UIImageView {
                //debugPrint("currentImgView.tag:\(currentImgView.tag)")
                if let lastImgView = self.selectedItems.last {
                    // 点到线的距离，垂足
                    let verticalPoint = self.distancePointToLine(p1: lastImgView.center, p2: self.currentPoint!, x0: currentImgView.center)
                    
                    let endX = self.currentPoint!.x
                    let endY = self.currentPoint!.y
                    let startX = lastImgView.center.x
                    let startY = lastImgView.center.y
                    let calculateX = currentImgView.center.x
                    let calculateY = currentImgView.center.y
                    var effectiveX = false
                    if endX >= startX {
                        effectiveX = (calculateX >= startX && calculateX <= endX)
                    } else {
                        effectiveX = (calculateX >= endX && calculateX <= startX)
                    }
                    var effectiveY = false
                    if endY >= startY {
                        effectiveY = (calculateY >= startY && calculateY <= endY)
                    } else {
                        effectiveY = (calculateY >= endY && calculateY <= startY)
                    }
                    
                    if verticalPoint.distance < 5.0 && effectiveX && effectiveY  {
                        // 符合条件，选中当前计算的点
                        currentImgView.image = UIImage(named: "橙色椭圆")
                        if !self.selectedItems.contains(currentImgView) {
                            self.selectedItems.append(currentImgView)
                        }
                    }
                } else {
                    if currentImgView.frame.contains(self.currentPoint!) {
                        currentImgView.image = UIImage(named: "橙色椭圆")
                        if !self.selectedItems.contains(currentImgView) {
                            self.selectedItems.append(currentImgView)
                        }
                    }
                }
            }
        }
        self.setNeedsDisplay()
        if sender.state == .ended && self.selectedItems.count > 0 {
            self.panFinished = true
            let pwdStr = self.getGestureStr()
            self.delegate?.panFinished(self, pwdStr)
        }
    }
    //计算两点间的距离
    fileprivate func calculateDistance(_ point1:CGPoint, _ point2:CGPoint) -> CGFloat {
        return sqrt(pow(point1.x-point2.x, 2.0) + pow(point1.y-point2.y, 2.0))
    }
    // 点到线的距离，以及垂足
    fileprivate func distancePointToLine(p1: CGPoint, p2:CGPoint, x0: CGPoint) ->(distance:Double, point:CGPoint) {
        
        let a = p2.y - p1.y
        let b = p1.x - p2.x
        let c = p2.x * p1.y - p1.x * p2.y
        
        let x = (b * b * x0.x - a * b * x0.y - a * c) / (a * a + b * b)
        let y = (-a * b * x0.x + a * a * x0.y - b * c) / (a * a + b * b)
        
        let d = abs((a * x0.x + b * x0.y + c)) / sqrt(pow(a, 2) + pow(b, 2))
        
        let pt = CGPoint(x: x, y: y)
        return (Double(d), pt)
    }
    
    fileprivate func getGestureStr() -> String {
        var resultStr = ""
        self.selectedItems.forEach { (imgView) in
            resultStr = resultStr.appendingFormat("%ld", imgView.tag)
        }
        return resultStr
    }
    //MARK: 清空手势
    func clearPanGesture()  {
        self.panFinished = false
        self.currentPoint = nil
        self.selectedItems.forEach { (imgView) in
            imgView.image = UIImage(named: "灰色椭圆")
        }
        self.selectedItems.removeAll()
        self.setNeedsDisplay()
    }
    
    func draw(_ type:GridUnlockResultType) {
        self.resultType = type
        self.setNeedsDisplay()
    }
    
    //MARK: draw
    override func draw(_ rect: CGRect) {
        if self.selectedItems.count == 0 { return }
        guard let currentP = self.currentPoint else { return }
        
        let path = UIBezierPath()
        path.lineWidth = 6.0
        path.lineJoinStyle = .round
        path.lineCapStyle = .round
        for i in 0..<self.selectedItems.count {
            let imgView = self.selectedItems[i]
            if i == 0 {
                path.move(to: imgView.center)
            } else {
                path.addLine(to: imgView.center)
            }
        }
        
        if self.panFinished { // 拖拽完成
            if self.resultType == .unknow { 
                UIColor.orange.set()
//                self.selectedItems.forEach { (imgView) in
//                    imgView.image = UIImage(named: "橙色椭圆")
//                }
            } else if self.resultType == .failed {
                UIColor.red.set()
                self.selectedItems.forEach { (imgView) in
                    imgView.image = UIImage(named: "红色椭圆")
                }
            } else if self.resultType == .success {
                UIColor.orange.set()
//                UIColor(red: 94.0/255.0, green: 195.0/255.0, blue: 49.0/255.0, alpha: 0.8).set()
//                self.selectedItems.forEach { (imgView) in
//                    imgView.image = UIImage(named: "gesture_selected")
//                }
            }
            self.resultType = .unknow // 绘制结束后设置为初始状态
        } else { // 拖拽中
            path.addLine(to: currentP)
            UIColor.orange.set()
        }
        path.stroke()
    }
    
    //MARK: init
    override init(frame: CGRect) {
        super.init(frame: frame)
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizer(_:)))
        pan.maximumNumberOfTouches = 1
        self.addGestureRecognizer(pan)
        
        self.setupUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:layoutSubviews
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let count = self.subviews.count
        let columns:Int = 3
        let itemW:Int = 58
        let itemH = itemW
        let margin = (Int(self.bounds.width) - columns * itemW) / (columns + 1)
        for i in 0..<count {
            let currentRow = i / columns
            let currentCol = i % columns
            let itemX = margin + (itemW + margin) * currentCol
            let itemY = margin + (itemW + margin) * currentRow
            let imgView = self.subviews[i]
            imgView.frame = CGRect(x: itemX, y: itemY, width: itemW, height: itemH)
        }
    }
    //MARK:setupUI
    func setupUI() {
        self.backgroundColor = .white
        for i in 0...8 {
            let imgView = UIImageView()
            imgView.image = UIImage(named: "灰色椭圆")
            imgView.tag = i
            self.addSubview(imgView)
        }
    }
    //MARK:lazy
    lazy var selectedItems: [UIImageView] = {
        let array = [UIImageView]()
        return array
    }()
}
