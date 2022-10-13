//
//  CQCrossFlowLayout.swift
//  CQSwift
//
//  Created by llbt2019 on 2022/9/2.
//  Copyright © 2022 李超群. All rights reserved.
//

import UIKit

class CQCrossFlowLayout: UICollectionViewFlowLayout {
    
    let decorationKind = "CQCrossDecorationViewID"
    
    override init() {
        super.init()
        
        
        self.register(CQCrossDecorationView.self, forDecorationViewOfKind: decorationKind)
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
    
    //MARK: 布局 element
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = self.collectionView else { return nil }
        guard let layoutAttributesArray = super.layoutAttributesForElements(in: rect) else { return nil }
        guard let flowLayoutDelegate = collectionView.delegate as? UICollectionViewDelegateFlowLayout else { return nil }
        
        var newAttributesArray = [UICollectionViewLayoutAttributes]()
        layoutAttributesArray.enumerated().forEach { (index, item) in
            newAttributesArray.append(item)
            if item.representedElementCategory != .cell { return }
            // cell的行间距
            let minimumLineSpace = flowLayoutDelegate.collectionView?(collectionView, layout: self, minimumLineSpacingForSectionAt: item.indexPath.section) ?? 0.0
            // cell的列间距
            let minimumInterSpace = flowLayoutDelegate.collectionView?(collectionView, layout: self, minimumInteritemSpacingForSectionAt: item.indexPath.section) ?? 0.0
            // section的边距
            let sectionInsets = flowLayoutDelegate.collectionView?(collectionView, layout: self, insetForSectionAt: item.indexPath.section) ?? UIEdgeInsets.zero
            let cellSize = flowLayoutDelegate.collectionView?(collectionView, layout: self, sizeForItemAt: item.indexPath) ?? CGSize.zero
            
            var cellX:CGFloat
            var cellY:CGFloat
            
            if item.indexPath.item == 0 {
                // 当前cell是第0个cell时， 就依据header设置当前cell的frame
                // 注意⚠️：如果当前section没有header需要依据上一个section的footer，
                //                如果上一个section没有footer就依据cell 设置当前cell的frame
                guard let headerAttributes = self.layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: item.indexPath) else {
                    return
                }
                //print("header: \(headerAttributes.frame)")
                cellX = sectionInsets.left
                cellY = headerAttributes.frame.maxY
                item.frame = CGRect(x: cellX, y: cellY, width: cellSize.width, height: cellSize.height)
                
                // 创建并添加 装饰（DecorationView）的LayoutAttributes
                if let decorationAttributes = self.layoutAttributesForDecorationView(ofKind: decorationKind, at: item.indexPath) {
                    let decorationX:CGFloat = 0.0
                    let decorationY:CGFloat = headerAttributes.frame.minY
                    let decorationWidth = headerAttributes.frame.width
                    let decorationHeight = item.frame.maxY + minimumLineSpace - decorationY
                    decorationAttributes.frame = CGRect(x: decorationX, y: decorationY, width: decorationWidth, height: decorationHeight)
                    //print("deco: \(decorationAttributes.frame)")
                    newAttributesArray.append(decorationAttributes)
                }
            } else {
                var attributesLast:UICollectionViewLayoutAttributes!
                if index == 0 {
                    // 如果 index == 0 说明是当前区域(rect)内的第一个,
                    // 需要用 layoutAttributesForItemAtIndexPath: 方法获取上一个Attributes
                    let indexPath = IndexPath(item: item.indexPath.item - 1, section: item.indexPath.section)
                    attributesLast = self.layoutAttributesForItem(at: indexPath)
                } else {
                    attributesLast = layoutAttributesArray[index - 1]
                }
                let tempX = attributesLast.frame.maxX + minimumInterSpace
                let availableW = collectionView.frame.width - tempX - sectionInsets.right
                
                if (availableW >= cellSize.width) {
                    cellX = tempX;
                    cellY = attributesLast.frame.origin.y;
                } else {
                    cellX = sectionInsets.left;
                    cellY = attributesLast.frame.maxY + minimumLineSpace;
                }
                item.frame = CGRect(x: cellX, y: cellY, width: cellSize.width, height: cellSize.height)
                // 重新计算DecorationView的frame
               let decorationAttributes = newAttributesArray.first { attributes in
                   if attributes.representedElementKind == decorationKind {
                        return attributes.indexPath.section == item.indexPath.section
                   }
                   return false
                }
                if decorationAttributes == nil { return } // 直接返回
                let x = decorationAttributes!.frame.minX
                let y = decorationAttributes!.frame.minY
                let width = decorationAttributes!.frame.width
                let height = item.frame.maxY + minimumLineSpace - y
                decorationAttributes!.frame = CGRect(x: x, y: y, width: width, height: height)
            }
        }
        return newAttributesArray
    }
    
//    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//        guard let collectionView = self.collectionView else { return nil }
//        guard let flowLayoutDelegate = collectionView.delegate as? UICollectionViewDelegateFlowLayout else { return nil }
//        // section的边距
//        let sectionInsets = flowLayoutDelegate.collectionView?(collectionView, layout: self, insetForSectionAt: indexPath.section) ?? UIEdgeInsets.zero
//        
//        let layoutAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, with: indexPath)
//        layoutAttributes.frame =
//        return layoutAttributes
//    }
    
    override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let layoutAttributes = UICollectionViewLayoutAttributes(forDecorationViewOfKind: elementKind, with: indexPath)
//        print(layoutAttributes.frame)
//        layoutAttributes.frame = CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0)
        layoutAttributes.zIndex = -1
        return layoutAttributes
    }
}
