//
//  CQTopViewModel.swift
//  CQSwift
//
//  Created by llbt2019 on 2020/4/16.
//  Copyright © 2020 李超群. All rights reserved.
//

import UIKit
@available(iOS 11.0, *)
protocol CQTopViewModelDelegate {
    func reduceAppEvent(_ model:CQAppModel?)
    func editAppEvent()
    
    func moreView(_ collectionView: CQTopView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
    func moreViewEndMove(_ collectionView: CQTopView,from originIndexPath:IndexPath?, to destinationIndexPath: IndexPath?)
}
@available(iOS 11.0, *)
class CQTopViewModel:NSObject,UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,CQMoreCellDelegate,CQMoreEditHeaderDelegate {

    weak var view:CQTopView?
    var delegate: CQTopViewModelDelegate?
    var editStatus = false
    
    var tempModelArray:[CQAppModel] = {
        let arrayM = CQMoreDataManager.shared.modelArray
        return arrayM
    }()
    
    // MARK: CQMoreCellDelegate
     func editButtonClickedEvent(_ sender: UIButton) {
         self.editStatus = true
         self.delegate?.editAppEvent()
     }
     // MARK: CQMoreCellDelegate
     func reduceOrAddAppEvent(_ cell: CQMoreCell) {
         self.delegate?.reduceAppEvent(cell.model)
     }
    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if self.editStatus == false {// 非编辑状态
            return CGSize(width: CQScreenW, height: 61.0)
        } else {// 编辑状态
            return CGSize(width:  CQScreenW, height: 45.0)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:  CQScreenW/4.0, height: 85.0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width:  CQScreenW, height: 10.0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    }
    // MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.editStatus == false {// 非编辑状态
            return 0//常用功能 在header里
        } else {// 编辑状态
            return 7 //首页展示 最多7个
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if self.editStatus == false {// 非编辑状态
            //非编辑状态下 常用功能组 cell 不存在
            return UICollectionViewCell()
        } else {// 编辑状态
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! CQMoreCell
            cell.indexPath = indexPath
            cell.delegate = self
            if self.tempModelArray.count > indexPath.item {
                let frequentlyModel = self.tempModelArray[indexPath.item]
                cell.setFrequentlyAppModel(frequentlyModel)
            } else {
                cell.setFrequentlyAppModel(nil)
            }
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            
            if self.editStatus == false {//非编辑状态
                let editHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: appEditHeaderID, for: indexPath) as! CQMoreEditHeader
                editHeader.setEditHeaderData(self.tempModelArray)
                editHeader.delegate = self
                return editHeader
            } else {//编辑状态
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: appHeaderID, for: indexPath) as! CQMoreHeader
                let sectionModel =  CQAppSectionModel()
                sectionModel.title = "首页展示"
                sectionModel.desTitleHidden = false
                header.sectionModel = sectionModel
                return header
            }
            
        } else {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: appFooterID, for: indexPath) as! CQMoreFooter
            return footer
        }
    }
    
    //MARK: get
    var cellID: String {
        get{
            return "cellID_\(NSStringFromClass(self.classForCoder))"
        }
    }
    var appHeaderID: String {
        get{
            return "moreHeaderID_\(NSStringFromClass(self.classForCoder))"
        }
    }
    var appFooterID: String {
        get{
            return "moreFooterID_\(NSStringFromClass(self.classForCoder))"
        }
    }
    var appEditHeaderID: String {
        get{
            return "moreEditHeaderID_\(NSStringFromClass(self.classForCoder))"
        }
    }
}
