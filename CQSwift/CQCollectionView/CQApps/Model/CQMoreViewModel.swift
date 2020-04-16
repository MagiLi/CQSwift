//
//  CQMoreViewModel.swift
//  CQSwift
//
//  Created by llbt2019 on 2020/4/16.
//  Copyright © 2020 李超群. All rights reserved.
//

import UIKit

@available(iOS 11.0, *)
protocol CQMoreViewModelDelegate {
    func addAppEvent(_ cell:CQMoreCell)
}

@available(iOS 11.0, *)
class CQMoreViewModel: NSObject,UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,CQMoreCellDelegate {
    var delegate: CQMoreViewModelDelegate?
    var topViewModel:CQTopViewModel!
    // MARK: CQMoreCellDelegate
    func reduceOrAddAppEvent(_ cell: CQMoreCell) {
        self.delegate?.addAppEvent(cell)
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: CQScreenW, height: 45.0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CQScreenW/4.0, height: 85.0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return .zero
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
        //return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    }
    // MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return CQMoreDataManager.shared.sectionModelArray.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if CQMoreDataManager.shared.sectionModelArray.count <= section { return 0}
        let sectionModel = CQMoreDataManager.shared.sectionModelArray[section]
        return sectionModel.list?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.topViewModel.cellID, for: indexPath) as! CQMoreCell
        cell.indexPath = indexPath
        cell.delegate = self
        if CQMoreDataManager.shared.sectionModelArray.count > indexPath.section {
            let sectionModel = CQMoreDataManager.shared.sectionModelArray[indexPath.section]
            if let model = sectionModel.list?[indexPath.item] {
                model.editing = self.topViewModel?.editStatus
                
                if self.topViewModel?.editStatus == true, model.status != .added {
                    _ = self.topViewModel?.tempModelArray.filter({ (frequentlyModel) -> Bool in
                        if frequentlyModel.appId == model.appId {
                            model.status = .added
                            return true
                        }
                        return false
                    })
                }
                cell.setAppsModel(model)
            } else {// 异常情况
                cell.setUnediteStatus()
            }
        } else {// 异常情况
            cell.setUnediteStatus()
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: self.topViewModel.appHeaderID, for: indexPath) as! CQMoreHeader
            if CQMoreDataManager.shared.sectionModelArray.count > indexPath.section {
                let sectionModel = CQMoreDataManager.shared.sectionModelArray[indexPath.section]
                header.sectionModel = sectionModel
            }
            return header
        } else {
            return CQMoreCell()
        }
    }
    // MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.topViewModel?.editStatus == true { return }
        if CQMoreDataManager.shared.sectionModelArray.count <= indexPath.section { return }
        let sectionModel = CQMoreDataManager.shared.sectionModelArray[indexPath.section]
        if let model = sectionModel.list?[indexPath.item] {
            //self.pushToNewVC(model: model)
        } else {
            //VKYHUD.showInfo("数据异常")
            
        }
    }
}
