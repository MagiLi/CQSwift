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
    override func prepare() {
        super.prepare()
        
        self.minimumLineSpacing = 0
        self.minimumInteritemSpacing = 0
    }
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = self.collectionView else { return nil }
        guard let layoutAttributesArray = super.layoutAttributesForElements(in: rect) else { return nil }
        //guard let flowLayoutDelegate = collectionView.delegate as? UICollectionViewDelegateFlowLayout else { return nil }
        // 添加 装饰（DecorationView）的LayoutAttributes
//        if let decorationAttributes = self.layoutAttributesForDecorationView(ofKind: decorationKind, at: layoutAttributes.indexPath) {
//            let decorationX:CGFloat = 0.0
//            let decorationY:CGFloat = headerAttributes.frame.minY
//            let decorationWidth = headerAttributes.frame.width
//            let decorationHeight = layoutAttributes.frame.maxY + minimumLineSpace - decorationY
//            decorationAttributes.frame = CGRect(x: decorationX, y: decorationY, width: decorationWidth, height: decorationHeight)
//            //print("deco: \(decorationAttributes.frame)")
//            attributesArray.append(decorationAttributes)
//        }
    }
    override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        super.layoutAttributesForDecorationView(ofKind: elementKind, at: indexPath)
    }
}
