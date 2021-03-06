//
//  CQTopView.swift
//  ccbpuhui
//
//  Created by llbt2019 on 2020/4/13.
//  Copyright © 2020 yhb. All rights reserved.
//

import UIKit

@available(iOS 11.0, *)
class CQTopView: UICollectionView {
    
    var viewModel:CQTopViewModel!
    
    
    fileprivate var lastPoint: CGPoint?
    fileprivate var originIndexPath: IndexPath?// 初始的indexPath
    fileprivate var pressedIndexPath: IndexPath?// 按住的indexPath

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
        if self.viewModel.editStatus == false { return }
        self.lastPoint = longPressGesture.location(in: self)
        self.pressedIndexPath = self.indexPathForItem(at: self.lastPoint!)
        self.originIndexPath = self.pressedIndexPath
        
        if let indexPath = self.pressedIndexPath, indexPath.section == 0, self.viewModel.tempModelArray.count > indexPath.item {
            
            guard let pressedCell = self.cellForItem(at: indexPath) else { return }
            self.pressedCell = pressedCell
            
            DispatchQueue.main.async {
                guard let snapshotCell = pressedCell.snapshotView(afterScreenUpdates: false) else { return }
                snapshotCell.frame = pressedCell.frame
                snapshotCell.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                if let view = self.superview {
                    view.addSubview(snapshotCell)
                } else {
                    self.addSubview(snapshotCell)
                }
                self.snapshotCell = snapshotCell
                
                self.pressedCell?.isHidden = true
            }
        }
        
    }
    
    //MARK:longPressChanged
    fileprivate func longPressChanged(_ longPressGesture:UILongPressGestureRecognizer) {
        guard let lastPoint = self.lastPoint else { return }
        guard let snapshotCell = self.snapshotCell else { return }
        guard let pressedIndexPath = self.pressedIndexPath else { return }
        
        let currentPoint = longPressGesture.location(in: self)
        let translateX = currentPoint.x - lastPoint.x
        let translateY = currentPoint.y - lastPoint.y
        let currentCenter = __CGPointApplyAffineTransform(snapshotCell.center, CGAffineTransform(translationX: translateX, y: translateY))
        snapshotCell.center = currentCenter
        self.lastPoint = longPressGesture.location(in: self)
        
        for cell in self.visibleCells {
            guard let toIndexPath = self.indexPath(for: cell) else { continue }
            if toIndexPath == self.pressedIndexPath { continue }
            if toIndexPath.section != 0 { continue }
            if self.viewModel.tempModelArray.count <= toIndexPath.item { continue }
            
            //计算中心距离
            let spacingX = abs(currentCenter.x - cell.center.x)
            let spacingY = abs(currentCenter.y - cell.center.y)
            if spacingX <= snapshotCell.bounds.size.width / 2.0 && spacingY <= snapshotCell.bounds.size.height / 2.0 {
                
                self.moveItem(at: pressedIndexPath, to: toIndexPath)
                
                self.viewModel.delegate?.moreView(self, moveItemAt: pressedIndexPath, to: toIndexPath)
                
                self.pressedIndexPath = toIndexPath
                return
            }
        }
        
    }
    //MARK:longPressEnd
    fileprivate func longPressEnd(_ longPressGesture: UILongPressGestureRecognizer) {
        
        self.viewModel.delegate?.moreViewEndMove(self, from: self.originIndexPath, to: self.pressedIndexPath)
        
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
        self.isScrollEnabled = false
        self.backgroundColor = .white
        self.showsVerticalScrollIndicator = false
    }
    
}
