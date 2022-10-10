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
        
        
         var attributesArray = layoutAttributesArray
        // 添加 装饰（DecorationView）的LayoutAttributes
        let indexPath = IndexPath(item: 0, section: 0)
        
        if let decorationAttributes = self.layoutAttributesForDecorationView(ofKind: decorationKind, at: indexPath) {
            let decorationX:CGFloat = 0.0
            let decorationY:CGFloat = 0.0
            let decorationWidth = collectionView.frame.width
            var decorationHeight:CGFloat!
            if let lastAtt = layoutAttributesArray.last {
                decorationHeight = lastAtt.frame.maxY
            } else {
                decorationHeight = collectionView.frame.height
            }
            decorationAttributes.frame = CGRect(x: decorationX, y: decorationY, width: decorationWidth, height: decorationHeight)
            //print("deco: \(decorationAttributes.frame)")
            attributesArray.append(decorationAttributes)
        }
        return attributesArray
    }
    override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        //super.layoutAttributesForDecorationView(ofKind: elementKind, at: indexPath)
        let layoutAttributes = UICollectionViewLayoutAttributes(forDecorationViewOfKind: elementKind, with: indexPath)
        layoutAttributes.zIndex = -1
        return layoutAttributes
    }
}
