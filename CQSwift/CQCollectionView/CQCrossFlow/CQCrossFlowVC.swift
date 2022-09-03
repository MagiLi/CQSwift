//
//  CQCrossFlowVC.swift
//  CQSwift
//
//  Created by llbt2019 on 2022/9/2.
//  Copyright © 2022 李超群. All rights reserved.
//

import UIKit

class CQCrossFlowVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let layout = CQCrossFlowLayout()
    let cellMargin = 22.0
    let sectionBottomMargin = 10.0
    let cellContentMargin:CGFloat = 8.0
    
    var sectionModelArray:[CQCFlowSectionModel]!
    
    //MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if self.sectionModelArray.count <= indexPath.section { return }
//        let sectionModel = self.sectionModelArray[indexPath.section]
//        guard let modelArray = sectionModel.data else { return }
        
        
    }
    //MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.sectionModelArray.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.sectionModelArray.count <= section { return 0 }
        let sectionModel = self.sectionModelArray[section]
        guard let modelArray = sectionModel.data else { return 0}
        return modelArray.count
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CQCrossFlowHeaderID", for: indexPath) as! CQCrossFlowHeader
            if self.sectionModelArray.count <= indexPath.section { return headerView }
            let sectionModel = self.sectionModelArray[indexPath.section]
            headerView.titleLb.text = sectionModel.title
            return headerView
        } else if kind == UICollectionView.elementKindSectionFooter {
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CQCrossFlowFooterID", for: indexPath) as! CQCrossFlowFooter
            return footerView
        }

        return UICollectionReusableView()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CQCrossFlowCellID", for: indexPath) as! CQCrossFlowCell
        if self.sectionModelArray.count <= indexPath.section { return cell }
        let sectionModel = self.sectionModelArray[indexPath.section]
        guard let modelArray = sectionModel.data, modelArray.count > indexPath.item else {
            return cell
        }
        cell.model = modelArray[indexPath.item]
        return cell
    }
    
    //MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.sectionModelArray.count <= indexPath.section { return .zero }
        let sectionModel = self.sectionModelArray[indexPath.section]
        guard let modelArray = sectionModel.data, modelArray.count > indexPath.item else {
            return .zero
        }
        
        let model = modelArray[indexPath.item]
        guard let content = model.content, content.count > 0 else { return .zero }
        
        let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: 30.0)
        let attributes:[NSAttributedString.Key : Any] = [.font:UIFont.systemFont(ofSize: 13.0)]
        let calculateSize = content.boundingRect(with: size, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: attributes, context: nil).size
        let itemMaxW = self.collectionView.frame.width - self.cellMargin * 2.0
        var itemW = calculateSize.width + self.cellContentMargin * 2.0 + 5.0
        if itemW > itemMaxW {
            itemW = itemMaxW
        }
        return CGSize(width: itemW, height: 30.0)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 30.0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 10.0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: cellMargin, bottom: sectionBottomMargin, right: cellMargin)
    }
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        guard let array = CQTransitionModelManager.toModelArray(self.dataArray, to: CQCFlowSectionModel.self) else { return }
        self.sectionModelArray = array
        self.view.addSubview(self.collectionView)
    }
    
    //MARK:
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let collectionViewX:CGFloat = 0.0
//        let collectionViewY:CGFloat = 0.0
        let collectionViewW = self.view.frame.width
        let collectionViewH = self.view.frame.height
        let collectionViewY:CGFloat = 0.0
        self.collectionView.frame = CGRect(x: collectionViewX, y: collectionViewY, width: collectionViewW, height: collectionViewH)
    }
     
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: self.layout)
        collectionView.alwaysBounceVertical = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .orange
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CQCrossFlowCell.self, forCellWithReuseIdentifier: "CQCrossFlowCellID")
        collectionView.register(CQCrossFlowHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CQCrossFlowHeaderID")
        collectionView.register(CQCrossFlowFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "CQCrossFlowFooterID")
        return collectionView
    }()
    

    lazy var dataArray: [[String:Any]] = {
        let array = [
            ["title":"搜索历史",
             "data":[
                ["content":"贷款", "time":"0"],
                ["content":"商户账单", "time":"1"],
                ["content":"对账", "time":"2"],
                ["content":"账单", "time":"3"],
                ["content":"商户账单商户账单", "time":"4"],
                ["content":"对账账", "time":"5"],
             ]],
            ["title":"热门推荐",
             "data":[
                ["content":"商户云贷", "time":"0"],
                ["content":"信用快贷", "time":"1"],
                ["content":"对账", "time":"2"],
                ["content":"财务管理", "time":"3"],
                ["content":"商户账单商户账单", "time":"4"],
                ["content":"对账账", "time":"5"],
             ]],
        ]
        return array
    }()
}
