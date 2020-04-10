//
//  CQAppsController.swift
//  CQSwift
//
//  Created by llbt2019 on 2020/4/3.
//  Copyright © 2020 李超群. All rights reserved.
//

import UIKit

class CQAppsController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CQAppsViewDelegate {
    
    var modelArray: [CQAppSectionModel]?
    
    //MARK:dataArray
    func getPlistData() {
        
        guard let url = Bundle.main.url(forResource: "AppDataList", withExtension: "plist") else {
            return
        }
        guard let array = NSArray(contentsOf: url) else { return }
        self.modelArray = CQTransitionModelManager.toModelArray(array, to:CQAppSectionModel.self) as [CQAppSectionModel]?
        self.appsView.reloadData()
        
//        guard let sectionModel = self.modelArray?.first else { return }
//        _ = CQModelManager.saveModel(sectionModel, CQAppSectionModel.kAppSectionModel)
//        
    }
    // MARK: CQAppsViewDelegate
    func appsView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        debugPrint("\(sourceIndexPath) +++ \(destinationIndexPath)")
    }
    func appsViewEndMove(_ collectionView: UICollectionView, from originIndexPath: IndexPath?, to destinationIndexPath: IndexPath?) {
        guard let fromIndexPath = originIndexPath, let toIndexPath = destinationIndexPath else {
            return
        }
        debugPrint("\(fromIndexPath) --- \(toIndexPath)")
    }
    
    // MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return (self.modelArray?.count ?? 0) + 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        }
        guard let model = self.modelArray?[section - 1] else {
            return 0
        }
        
        return model.list?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: appCellID, for: indexPath) as! CQAppCell
        if indexPath.section == 0 {
            
        } else {
            if let sectionModel = self.modelArray?[indexPath.section - 1] {
                if let model = sectionModel.list?[indexPath.item] {
                    cell.updateUI(model, indexPath)
                }
            }
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: appHeaderID, for: indexPath) as! CQAppHeaderView
            if indexPath.section == 0 {
                headerView.setHeaderTitleLab(indexPath.section)
            } else {
                if let sectionModel = self.modelArray?[indexPath.section - 1] {
                    headerView.setHeaderModel(sectionModel)
                } else {
                    headerView.setHeaderTitleLab(indexPath.section)
                }
            }
            return headerView
        } else {
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: appFooterID, for: indexPath) as! CQAppFooterView
            footerView.setFooterTitleLab(indexPath.section)
            return footerView
        }
    }
    
    //MARK:UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: cellW, height: cellW)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: CQScreenW, height: 25.0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        
        self.getPlistData()
    }
    //MARK:viewDidLayoutSubviews
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let appsViewW = self.view.frame.width
        let appsViewH = self.view.frame.height
        let appsViewX = CGFloat(0.0)
        let appsViewY = CGFloat(0.0)
        self.appsView.frame = CGRect(x: appsViewX, y: appsViewY, width: appsViewW, height: appsViewH)
    }
    //MARK:setupUI
    func setupUI() {
        self.title = "APP"
        self.view.addSubview(appsView)
    }
    
    //MARK:lazy
    lazy var appsView: CQAppsView = {
        let layout = CQAppLayout()
        let frame = CGRect(x: 0.0, y: 0.0, width: CQScreenW, height: CQScreenH)
        let view = CQAppsView(frame: frame, collectionViewLayout: layout)
        view.register(CQAppCell.self, forCellWithReuseIdentifier: appCellID)
        view.register(CQAppHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: appHeaderID)
        view.register(CQAppFooterView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: appFooterID)
        view.delegate = self
        view.dataSource = self
        view.appsViewDelegate = self
        return view
    }()
    //MARK:get
    var cellW: CGFloat {
        get {
            return floor((CQScreenW - 50.0)/4.0)
        }
    }
    var appCellID: String {
        get{
            return "appCellID_\(NSStringFromClass(self.classForCoder))"
        }
    }
    var appHeaderID: String {
        get{
            return "appHeaderID_\(NSStringFromClass(self.classForCoder))"
        }
    }
    var appFooterID: String {
        get{
            return "appFooterID_\(NSStringFromClass(self.classForCoder))"
        }
    }
}
