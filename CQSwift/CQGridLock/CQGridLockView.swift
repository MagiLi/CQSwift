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
            if let imgView = subView as? UIImageView, imgView.frame.contains(self.currentPoint!) {
                imgView.image = UIImage(named: "橙色椭圆")
                if !self.selectedItems.contains(imgView) {
                    self.selectedItems.append(imgView)
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
            } else if self.resultType == .failed {
                UIColor.red.set()
                self.selectedItems.forEach { (imgView) in
                    imgView.image = UIImage(named: "红色椭圆")
                }
            } else if self.resultType == .success {
                //UIColor(red: 94.0/255.0, green: 195.0/255.0, blue: 49.0/255.0, alpha: 0.8).set()
                UIColor.orange.set()
            }
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
