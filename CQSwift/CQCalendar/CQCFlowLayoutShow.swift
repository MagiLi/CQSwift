//
//  CQCFlowLayoutShow.swift
//  CQSwift
//
//  Created by llbt2019 on 2022/9/30.
//  Copyright © 2022 李超群. All rights reserved.
//

import UIKit

class CQCFlowLayoutShow: UICollectionViewFlowLayout  {
    let decorationKind = "CQCalendarDecorationViewID"
    override init() {
        super.init()
        self.register(CQCalendarDecorationView.self, forDecorationViewOfKind: decorationKind)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepare() {
        super.prepare()
        
        self.minimumLineSpacing = 0
        self.minimumInteritemSpacing = 0
    }
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let layoutAttributesArray = super.layoutAttributesForElements(in: rect) else { return nil }
        guard let collectionView = self.collectionView else { return nil }
        //guard let flowLayoutDelegate = collectionView.delegate as? UICollectionViewDelegateFlowLayout else { return nil }
        var newAttributesArray = [UICollectionViewLayoutAttributes]()
        layoutAttributesArray.enumerated().forEach { (index, item) in
            newAttributesArray.append(item)
            if item.indexPath.section == 0 && item.indexPath.item == 0 {  // section为0时 创建并添加 装饰
                guard let decorationAttributes = self.layoutAttributesForDecorationView(ofKind: decorationKind, at: item.indexPath) else { return }
                // section为0和1时 共用该 装饰
                let decorationX:CGFloat = 0.0
                let decorationY:CGFloat = 0.0
                let decorationWidth = collectionView.frame.width
                let decorationHeight = item.frame.maxY
                decorationAttributes.frame = CGRect(x: decorationX, y: decorationY, width: decorationWidth, height: decorationHeight)
                //print("deco: \(decorationAttributes.frame)")
                newAttributesArray.append(decorationAttributes)
            } else if item.indexPath.section == 1 { // section为0时 重置  装饰 的layoutAttributes
                // 如果一屏展示不出来section为1下的footer就需要隐藏该行代码
                if item.representedElementCategory != .supplementaryView { return }
                // 重新计算DecorationView的frame
                let decorationAttributes = newAttributesArray.first { attributes in
                    if attributes.representedElementKind == decorationKind {
                        return attributes.indexPath.section == 0
                    }
                    return false
                }
                if decorationAttributes == nil { return } // 直接返回
                let x = decorationAttributes!.frame.minX
                let y = decorationAttributes!.frame.minY
                let width = decorationAttributes!.frame.width
                let height = item.frame.maxY
                decorationAttributes!.frame = CGRect(x: x, y: y, width: width, height: height)
            }
           
        }
        return newAttributesArray
//        // 添加 装饰（DecorationView）的LayoutAttributes
//        var attributesArray = layoutAttributesArray
//        let indexPath = IndexPath(item: 0, section: 0)
//        if let decorationAttributes = self.layoutAttributesForDecorationView(ofKind: decorationKind, at: indexPath) {
//            let decorationX:CGFloat = 0.0
//            let decorationY:CGFloat = 0.0
//            let decorationWidth = collectionView.frame.width
//            var decorationHeight:CGFloat!
//            if let lastAtt = layoutAttributesArray.last {
//                decorationHeight = lastAtt.frame.maxY
//            } else {
//                decorationHeight = collectionView.frame.height
//            }
//            decorationAttributes.frame = CGRect(x: decorationX, y: decorationY, width: decorationWidth, height: decorationHeight)
//            //print("deco: \(decorationAttributes.frame)")
//            attributesArray.append(decorationAttributes)
//        }
//        return attributesArray
    }
    // 此外，所有布局子类都应该实现-layoutAttributesForItemAtIndexPath
    // 以便根据需要返回特定索引下的布局属性实例（LayoutAttributes）。
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return super.layoutAttributesForItem(at: indexPath)
    }
    override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        //super.layoutAttributesForDecorationView(ofKind: elementKind, at: indexPath)
        let layoutAttributes = UICollectionViewLayoutAttributes(forDecorationViewOfKind: elementKind, with: indexPath)
        layoutAttributes.zIndex = -1
        return layoutAttributes
    }
}
