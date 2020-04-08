//
//  CQAppsView.swift
//  CQSwift
//
//  Created by llbt2019 on 2020/4/3.
//  Copyright © 2020 李超群. All rights reserved.
//

import UIKit

class CQAppsView: UICollectionView {
    
    var editing:Bool?
    
    fileprivate var lastPoint: CGPoint?
    fileprivate var pressedIndexPath: IndexPath?
    fileprivate var toIndexPath: IndexPath?
    fileprivate var pressedCell: UICollectionViewCell?
    fileprivate var snapshotCell: UIView?
    
    @objc func longPress(_ longPressGesture:UILongPressGestureRecognizer) {
        switch longPressGesture.state {
        case .began:
            self.longPressBegin(longPressGesture)
        case .changed:
            self.longPressChanged(longPressGesture)
        case .cancelled:
            self.longPressEnd(longPressGesture)
        case .ended:
            self.longPressEnd(longPressGesture)
        default: break
        }
    }
    
    //MARK:longPressBegin
    fileprivate func longPressBegin(_ longPressGesture:UILongPressGestureRecognizer) {
        if self.editing == false {
            self.editing = true
        }
        
        self.lastPoint = longPressGesture.location(in: self)
        self.pressedIndexPath = self.indexPathForItem(at: self.lastPoint!)
        if let indexPath = self.pressedIndexPath, indexPath.section == 0 {
            
            guard let pressedCell = self.cellForItem(at: indexPath) else { return }
            self.pressedCell = pressedCell
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                guard let snapshotCell = pressedCell.snapshotView(afterScreenUpdates: false) else { return }
                snapshotCell.frame = pressedCell.frame
                snapshotCell.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                self.addSubview(snapshotCell)
                self.snapshotCell = snapshotCell
                
                self.pressedCell?.isHidden = true
            }
        }
      
    }
    
    //MARK:longPressChanged
    fileprivate func longPressChanged(_ longPressGesture:UILongPressGestureRecognizer) {
        guard let lastPoint = self.lastPoint else { return }
        guard let pressedCell = self.pressedCell else { return }
        guard let snapshotCell = self.snapshotCell else { return }
        guard let pressedIndexPath = self.pressedIndexPath else { return }
        
        let currentPoint = longPressGesture.location(in: self)
        let translateX = currentPoint.x - lastPoint.x
        let translateY = currentPoint.y - lastPoint.y
        let currentCenter = __CGPointApplyAffineTransform(snapshotCell.center, CGAffineTransform(translationX: translateX, y: translateY))
        snapshotCell.center = currentCenter
        self.lastPoint = longPressGesture.location(in: self)

        for cell in self.visibleCells {
            guard let indexPath = self.indexPath(for: cell) else { return }
            if indexPath == self.pressedIndexPath { continue }
            
            //计算中心距离
            let spacingX = fabs(currentCenter.x - cell.center.x)
            let spacingY = fabs(currentCenter.y - cell.center.y)
            if spacingX <= pressedCell.bounds.size.width / 2.0 && spacingY <= pressedCell.bounds.size.height / 2.0 {
                self.toIndexPath = indexPath
                if self.toIndexPath?.section != 0 { return }
                
                self.moveItem(at: pressedIndexPath, to: indexPath)
                
                self.pressedIndexPath = self.toIndexPath

            }
        }
        
    }
    //MARK:longPressEnd
    fileprivate func longPressEnd(_ longPressGesture: UILongPressGestureRecognizer) {
        UIView.animate(withDuration: 0.25, animations: {
            self.snapshotCell?.transform = .identity
            self.snapshotCell?.center = self.pressedCell?.center ?? .zero
        }) { (finished) in
            self.pressedCell?.isHidden = false
            self.snapshotCell?.removeFromSuperview()
            self.snapshotCell = nil
        }
    }
    func addLongPressGestureRecognizer() {
        let longPress = UILongPressGestureRecognizer.init(target: self, action: #selector(longPress(_:)))
        self.addGestureRecognizer(longPress)
    }
    
    //MARK:init
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.setupUI()
        self.addLongPressGestureRecognizer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK:layoutSubviews
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    //MARK:setupUI
    func setupUI() {
        self.alwaysBounceVertical = true
        self.backgroundColor = .white
    }

}
