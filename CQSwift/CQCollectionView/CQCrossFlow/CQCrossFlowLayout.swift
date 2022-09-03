//
//  CQCrossFlowLayout.swift
//  CQSwift
//
//  Created by llbt2019 on 2022/9/2.
//  Copyright © 2022 李超群. All rights reserved.
//

import UIKit

class CQCrossFlowLayout: UICollectionViewFlowLayout {
    
    override init() {
        super.init()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepare() {
        super.prepare()
    }
    //MARK: calculateLayout
    func calculateLayout() {
        
    }
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = self.collectionView else { return nil }
        guard let layoutAttributesArray = super.layoutAttributesForElements(in: rect) else { return nil }
        guard let flowLayoutDelegate = collectionView.delegate as? UICollectionViewDelegateFlowLayout else { return nil }
        layoutAttributesArray.enumerated().forEach { (index, layoutAttributes) in
            if layoutAttributes.representedElementCategory != .cell { return }
            // cell的行间距
            let minimumLineSpace = flowLayoutDelegate.collectionView?(collectionView, layout: self, minimumLineSpacingForSectionAt: layoutAttributes.indexPath.section) ?? 0.0
            // cell的列间距
            let minimumInterSpace = flowLayoutDelegate.collectionView?(collectionView, layout: self, minimumInteritemSpacingForSectionAt: layoutAttributes.indexPath.section) ?? 0.0
            // cell的边距
            let cellInsets = flowLayoutDelegate.collectionView?(collectionView, layout: self, insetForSectionAt: layoutAttributes.indexPath.section) ?? UIEdgeInsets.zero
            let cellSize = flowLayoutDelegate.collectionView?(collectionView, layout: self, sizeForItemAt: layoutAttributes.indexPath) ?? CGSize.zero
            
            var cellX:CGFloat
            var cellY:CGFloat
            
            if layoutAttributes.indexPath.item == 0 {
                let headerAttributes = self.layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: layoutAttributes.indexPath)
                cellX = cellInsets.left
                cellY = headerAttributes?.frame.maxY ?? 0.0
                layoutAttributes.frame = CGRect(x: cellX, y: cellY, width: cellSize.width, height: cellSize.height)
            } else {
                var attributesLast:UICollectionViewLayoutAttributes!
                if index == 0 {// 如果 index == 0 说明当前区域(rect)内是第一个,需要用 layoutAttributesForItemAtIndexPath: 方法获取上一个Attributes
                    let indexPath = IndexPath(item: layoutAttributes.indexPath.item - 1, section: layoutAttributes.indexPath.section)
                    attributesLast = self.layoutAttributesForItem(at: indexPath)
                } else {
                    attributesLast = layoutAttributesArray[index - 1]
                }
                let tempX = attributesLast.frame.maxX + minimumInterSpace
                let availableW = collectionView.frame.width - tempX - cellInsets.right
                
                if (availableW >= cellSize.width) {
                    cellX = tempX;
                    cellY = attributesLast.frame.origin.y;
                } else {
                    cellX = cellInsets.left;
                    cellY = attributesLast.frame.maxY + minimumLineSpace;
                }
                layoutAttributes.frame = CGRect(x: cellX, y: cellY, width: cellSize.width, height: cellSize.height)
            }
        }
        return layoutAttributesArray
    }
}
